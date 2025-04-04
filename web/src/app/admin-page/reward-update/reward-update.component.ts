import { NgIf } from '@angular/common';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { environment } from '../../../environments/environment';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../api/api.service';

@Component({
  selector: 'app-reward-update',
  standalone: true,
  imports: [NgIf, FormsModule],
  templateUrl: './reward-update.component.html',
  styleUrl: './reward-update.component.scss'
})
export class RewardUpdateComponent implements OnInit {

  constructor(private router: Router, private http: HttpClient, private route: ActivatedRoute, public api: ApiService) { }

  loading = true;
  ngOnInit(): void {
    this.route.paramMap.subscribe((param) => {
      // console.log(param.get('id'));
      if (param.get('id')) {
        const params = new HttpParams().set('id', Number(param.get('id')));
        this.http.get(`${environment.API_URL}/get-reward`, { params }).subscribe(async (response: any) => {
          // console.log(response);

          let item = response.reward;
          this.data.id = item.id

          this.data.reward_name = item.reward_name
          this.data.description = item.description

          this.data.startDate = new Date(item.startDate).toISOString().slice(0, 10)
          this.data.endDate = new Date(item.endDate).toISOString().slice(0, 10)
          this.data.stock = item.stock
          this.data.cost = item.cost
          this.data.path = item.img
          let path = `${environment.API_URL}${item.img.replace('src', '')}`;
          path = await this.api.checkImageExists(path) != 500 && item.img.trim() != '' ? path : ''
          this.img_path = path;

          this.loading = false
        })
      } else {
        this.loading = false
      }
    });
  }

  img_path: string | null = null//base64
  img_file: File | null = null;

  onFileSelected(event: Event) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
      this.img_file = file
      const reader = new FileReader();
      reader.onload = () => {
        this.img_path = reader.result as string;
      };
      reader.readAsDataURL(file);
    }
  }

  data: Reward = new Reward()

  upload_img(): Promise<string | null> {
    return new Promise((resolve, reject) => {
      let formData = new FormData();
      if (this.img_file) {
        formData.append('file', this.img_file);
        this.http.post(`${environment.API_URL}/upload/reward`, formData).subscribe(
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
    this.submitting = false;
    const imgPath = await this.upload_img();
    // console.log("🚀 Image Path:", imgPath);

    this.http.post(`${environment.API_URL}/update-reward`, {
      id: this.data.id,
      reward_name: this.data.reward_name,
      description: this.data.description,
      startDate: new Date(this.data.startDate),
      endDate: new Date(this.data.endDate),
      img: imgPath || this.data.path,
      stock: +this.data.stock,
      cost: +this.data.cost
    }).subscribe((response: any) => {
      // console.log(response);
      if (response.status == 'success') {
        this.api.addAlert('success', 'บันทึกข้อมูลสำเร็จ');
        // alert('บันทึกข้อมูลสำเร็จ')
        this.router.navigate(['/admin/reward']);
      }
    }, error => {
      this.submitting = false;
      // alert('บันทึกข้อมูลไม่สำเร็จ')
      this.api.addAlert('unsuccessful', 'บันทึกข้อมูลไม่สำเร็จ');
      console.error('Error:', error);
    });
  }

}

class Reward {
  id = 0
  reward_name = ''
  description = ''
  img = ''
  startDate = new Date(new Date().setHours(7, 0, 0, 0)).toISOString().slice(0, 10)
  endDate = new Date(new Date().setHours(31, 0, 0, 0)).toISOString().slice(0, 10)
  stock: number = 0
  cost: number = 0
  path = ''
}