import { NgIf } from '@angular/common';
import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { environment } from '../../../environments/environment';
import { HttpClient, HttpParams } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../api/api.service';

@Component({
  selector: 'app-user-update',
  standalone: true,
  imports: [NgIf, FormsModule],
  templateUrl: './user-update.component.html',
  styleUrl: './user-update.component.scss'
})
export class UserUpdateComponent implements OnInit {

  constructor(private router: Router, private http: HttpClient, private route: ActivatedRoute, public api: ApiService) { }

  loading = true;
  ngOnInit(): void {
    this.route.paramMap.subscribe((param) => {
      // console.log(param.get('id'));
      const profile_id = param.get('id')
      if (profile_id) {
        const params = new HttpParams().set('profile_id', profile_id);
        this.http.get(`${environment.API_URL}/profile`, { params }).subscribe(async (response: any) => {
          // console.log(response);

          let item = response.profile;
          this.data.email = item.user.email;
          this.data.Role = item.user.role.role_name;
          this.data.username = item.profile_name;
          this.data.first_name = item.first_name;
          this.data.last_name = item.last_name;
          this.data.email = item.user.email;
          this.data.mobileNo = item.phone;
          this.data.gender = item.gender;
          this.data.Status = item.user.active;
          this.data.birthday = new Date(item.birth_date).toISOString().slice(0, 10)
          this.data.path = item.profile_img
          let path = item.profile_img ? `${environment.API_URL}${item.profile_img.replace('src', '')}` : '';
          path = await this.api.checkImageExists(path) != 500 ? path : ''
          this.img_path = path;
          this.loading = false
        })
      } else {
        this.loading = false
      }
    });
  }


  img_path = ''//base64

  img_file: File | null = null;

  onFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const file = input.files[0];

      // ตรวจสอบว่าเป็นไฟล์รูปภาพ
      if (!file.type.startsWith('image/')) {
        alert('กรุณาเลือกไฟล์รูปภาพ');
        return;
      }

      this.img_file = file;

      const reader = new FileReader();
      reader.onload = () => {
        this.img_path = reader.result as string;
      };
      reader.readAsDataURL(file);
    }
  }

  data: User = new User()

  upload_img(): Promise<string | null> {
    return new Promise((resolve, reject) => {
      let formData = new FormData();
      if (this.img_file) {
        formData.append('file', this.img_file);
        this.http.post(`${environment.API_URL}/upload/profile`, formData).subscribe(
          (item: any) => {
            if (item.path) {
              resolve(item.path);
            } else {
              resolve(null);
            }
          },
          (error) => {
            console.error("🚨 Upload Error:", error);
            reject(error);
          }
        );
      } else {
        resolve(null);
      }
    });
  }

  submitting = false;
  async submit() {
    this.submitting = true;
    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    let e = emailPattern.test(this.data.email);
    if (!e) {
      alert('กรุณาระบุ email ให้ถูกต้อง')
      return
    }
    const imgPath = await this.upload_img();
    // console.log("🚀 Image Path:", imgPath);

    // console.log(typeof this.data.Status);

    this.http.post(`${environment.API_URL}/register`, {
      email: this.data.email,
      role: this.data.Role,
      profile: {
        profile_name: this.data.username,
        first_name: this.data.first_name,
        last_name: this.data.last_name,
        contact_email: this.data.email,
        phone: this.data.mobileNo,
        gender: this.data.gender,
        birth_date: new Date(this.data.birthday),
        profile_img: imgPath || this.data.path
      },
      active: this.data.Status
    }).subscribe(
      async (response: any) => {
        // console.log("✅ Register Success:", response);
        if (response.status === 'success') {
          this.router.navigate(['/admin/users']).then(() => {
            // alert('บันทึกข้อมูลสำเร็จ')
            this.api.addAlert('success', 'บันทึกข้อมูลสำเร็จ');
            window.location.reload();
          });
        }

      },
      (error) => {
        this.submitting = false;
        // alert('บันทึกข้อมูลไม่สำเร็จ')
        this.api.addAlert('unsuccessful', 'บันทึกข้อมูลไม่สำเร็จ');
        console.error("🚨 Register Error:", error);
      }
    );
  }

}
class User {
  username = ''
  first_name = ''
  last_name = ''
  email = ''
  mobileNo = ''
  birthday = ''
  gender = 'Other'
  Role = 'admin'
  Status: boolean = true
  path: string | null = null
}