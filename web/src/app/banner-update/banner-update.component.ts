import { NgIf } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';

@Component({
  selector: 'app-banner-update',
  standalone: true,
  imports: [NgIf, FormsModule],
  templateUrl: './banner-update.component.html',
  styleUrl: './banner-update.component.scss'
})
export class BannerUpdateComponent {

  constructor(private router: Router, private http: HttpClient) { }

  data: Banner = new Banner()
  img_path = ''//base64

  onFileSelected(event: Event) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        this.img_path = reader.result as string;
      };
      reader.readAsDataURL(file);
    }
  }

  goToLink(url: string) {
    this.router.navigate([`${url}`]).finally(() => {
      this.router.url
    })
  }

  submit() {
    this.http.post(`${environment.API_URL}/update-banner`, {
      id: this.data.id,
      title: this.data.title,
      description: this.data.description,
      startDate: new Date(this.data.startDate),
      endDate: new Date(this.data.endDate),
      path: this.data.path
    }).subscribe(async (response: any) => {
      console.log(response);
      if (response.status == 'success') this.router.navigate(['/admin/banner'])
    }, error => {
      console.error('Error:', error);
    });
  }

}
class Banner {
  id = 0
  title = ''
  description = ''
  path = ''
  startDate = ''
  endDate = ''
}