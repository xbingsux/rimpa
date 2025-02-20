import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { DatePipe, NgFor } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { ApiService } from '../api/api.service';

@Component({
  selector: 'app-banner-management',
  standalone: true,
  imports: [DatePipe, NgFor],
  templateUrl: './banner-management.component.html',
  styleUrl: './banner-management.component.scss'
})
export class BannerManagementComponent {

  constructor(private router: Router, private http: HttpClient, public api: ApiService) { }
  tz = environment.timeZone;
  list: any[] = []
  ngOnInit(): void {
    this.http.post(`${environment.API_URL}/list-banner`, {}).subscribe(async (response: any) => {
      // console.log(response.banner);
      this.list = response.banner
    }, error => {
      console.error('Error:', error);
    });
  }  
}
