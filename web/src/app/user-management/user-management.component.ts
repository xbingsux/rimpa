import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { DatePipe, NgFor, NgIf } from '@angular/common';

@Component({
  selector: 'app-user-management',
  standalone: true,
  imports: [DatePipe, NgFor, NgIf],
  templateUrl: './user-management.component.html',
  styleUrl: './user-management.component.scss'
})
export class UserManagementComponent {

  constructor(private router: Router, private http: HttpClient) { }
  tz = environment.timeZone;
  list: any[] = []
  ngOnInit(): void {
    this.http.post(`${environment.API_URL}/list-profile`, {}).subscribe(async (response: any) => {
      console.log(response.profile);
      this.list = response.profile
    }, error => {
      console.error('Error:', error);
    });
  }

  getImg(url: string) {
    return `${environment.API_URL}${url.replace('src', '')}`
  }

  goToLink(url: string) {
    this.router.navigate([`${url} `]).finally(() => {
      this.router.url
    })
  }

  toEdit(url: string, key: string) {
    this.router.navigate([`${url}/${key}`])
  }

  toDelete() {

  }
}
