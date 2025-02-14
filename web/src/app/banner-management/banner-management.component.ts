import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { DatePipe, NgFor } from '@angular/common';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-banner-management',
  standalone: true,
  imports: [DatePipe, NgFor],
  templateUrl: './banner-management.component.html',
  styleUrl: './banner-management.component.scss'
})
export class BannerManagementComponent {

  constructor(private router: Router, private http: HttpClient) { }
  tz = environment.timeZone;
  list: any[] = []
  ngOnInit(): void {
    this.http.post(`${environment.API_URL}/list-banner`, {}).subscribe(async (response: any) => {
      console.log(response.banner);
      this.list = response.banner
    }, error => {
      console.error('Error:', error);
    });
  }

  goToLink(url: string) {
    this.router.navigate([`${url}`]).finally(() => {
      this.router.url
    })
  }

  toEdit() {

  }

  toDelete() {

  }
}
