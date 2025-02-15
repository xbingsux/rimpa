import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { DatePipe, NgFor, NgIf } from '@angular/common';
import { ApiService } from '../api/api.service'
@Component({
  selector: 'app-user-management',
  standalone: true,
  imports: [DatePipe, NgFor, NgIf],
  templateUrl: './user-management.component.html',
  styleUrl: './user-management.component.scss'
})
export class UserManagementComponent implements OnInit {

  constructor(private http: HttpClient, public api: ApiService) { }
  tz = environment.timeZone;
  list: any[] = []

  ngOnInit(): void {
    this.http.post(`${environment.API_URL}/list-profile`, {}).subscribe(async (response: any) => {
      console.log(response.profile);

      this.list = response.profile

      this.list.map(async (item: any) => {
        let url = item.profile.profile_img
        if (url) {
          const status = await this.api.checkImageExists(`${environment.API_URL}${url.replace('src', '')}`)
          if (status === 500 || status === 404) item.profile.profile_img = null;
        }
        return item;
      })
    }, error => {
      console.error('Error:', error);
    });

  }

  getImg(url: string) {
    let path = `${environment.API_URL}${url.replace('src', '')}`
    return path
  }



  toDelete() {

  }
}
