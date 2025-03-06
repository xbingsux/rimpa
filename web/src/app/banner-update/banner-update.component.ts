import { NgIf } from '@angular/common';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { ApiService } from '../api/api.service';

@Component({
  selector: 'app-banner-update',
  standalone: true,
  imports: [NgIf, FormsModule],
  templateUrl: './banner-update.component.html',
  styleUrl: './banner-update.component.scss'
})
export class BannerUpdateComponent {

  constructor(private router: Router, private http: HttpClient, private route: ActivatedRoute, public api: ApiService) { }

  ngOnInit(): void {
    this.route.paramMap.subscribe((param) => {
      // console.log(param.get('id'));
      if (param.get('id')) {
        const params = new HttpParams().set('id', Number(param.get('id')));
        this.http.get(`${environment.API_URL}/event/get-banner`, { params }).subscribe(async (response: any) => {
          // console.log(response);
          let item = response.banner;
          this.data.id = item.id;
          this.data.title = item.title;
          this.data.description = item.description
          this.data.startDate = new Date(item.startDate).toISOString().slice(0, 10)
          this.data.endDate = new Date(item.endDate).toISOString().slice(0, 10)
          this.data.path = item.path;
          let path = `${environment.API_URL}${item.path.replace('src', '')}`;
          path = await this.api.checkImageExists(path) != 500 ? path : ''
          this.img_path = path;
        })
      }
    });
  }

  data: Banner = new Banner()
  img_path = ''//base64

  onFileSelected(event: Event) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
      this.img_file = file;
      const reader = new FileReader();
      reader.onload = () => {
        this.img_path = reader.result as string;
      };
      reader.readAsDataURL(file);
    }
  }

  img_file: File | null = null;

  upload_img(): Promise<string | null> {
    return new Promise((resolve, reject) => {
      let formData = new FormData();
      if (this.img_file) {
        formData.append('file', this.img_file);
        this.http.post(`${environment.API_URL}/upload/banner`, formData).subscribe(
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

  async submit() {
    const imgPath = await this.upload_img();
    // console.log("🚀 Image Path:", imgPath);

    this.http.post(`${environment.API_URL}/update-banner`, {
      id: this.data.id,
      title: this.data.title,
      description: this.data.description,
      startDate: new Date(this.data.startDate),
      endDate: new Date(this.data.endDate),
      path: imgPath || this.data.path
    }).subscribe(async (response: any) => {
      // console.log(response);
      if (response.status == 'success') {
        alert('บันทึกข้อมูลสำเร็จ')
        this.router.navigate(['/admin/banner'])
      }
    }, error => {
      alert('บันทึกข้อมูลไม่สำเร็จ')
      console.error('Error:', error);
    });
  }

}
class Banner {
  id = 0
  title = ''
  description = ''
  path = ''
  startDate = new Date(new Date().setHours(7, 0, 0, 0)).toISOString().slice(0, 10)
  endDate = new Date(new Date().setHours(31, 0, 0, 0)).toISOString().slice(0, 10)
}