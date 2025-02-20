import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { DatePipe, NgFor, NgIf } from '@angular/common';
import { ApiService } from '../api/api.service'
import { FormsModule } from '@angular/forms';
@Component({
  selector: 'app-user-management',
  standalone: true,
  imports: [DatePipe, NgFor, NgIf, FormsModule],
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

      this.list_Filter()
    }, error => {
      console.error('Error:', error);
    });

  }

  getImg(url: string) {
    let path = `${environment.API_URL}${url.replace('src', '')}`
    return path
  }

  //Search Func
  search = ''
  page_no = 0;
  last_page = 0;
  readonly max_item = 10
  data: any[] = []
  list_Filter(): any {
    let n = 0;
    let start = this.page_no * this.max_item;
    let end = start + this.max_item;
    this.data = this.list.filter((item) => {
      if (
        this.search == '' ||
        item.profile.profile_name.toLocaleLowerCase().indexOf(this.search.toLocaleLowerCase()) != -1 ||
        item.email.toLocaleLowerCase().indexOf(this.search.toLocaleLowerCase()) != -1
      ) {
        n++
        return item;
      }
    }).slice(start, end);
    this.last_page = Math.ceil(n / end);
    console.log('test');
  }

  updatePage(page_no: number) {
    if (page_no >= 0 && page_no < this.last_page) {
      this.page_no = page_no;
    }
    this.list_Filter()
  }
}
