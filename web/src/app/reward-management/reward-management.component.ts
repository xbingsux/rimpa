import { HttpClient } from '@angular/common/http';
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { DatePipe, NgFor, NgIf } from '@angular/common';
import { ApiService } from '../api/api.service';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-reward-management',
  standalone: true,
  imports: [NgFor, DatePipe, NgIf, FormsModule],
  templateUrl: './reward-management.component.html',
  styleUrl: './reward-management.component.scss'
})
export class RewardManagementComponent {

  constructor(private router: Router, private http: HttpClient, public api: ApiService) { }
  tz = environment.timeZone;
  list: any[] = []

  ngOnInit(): void {
    this.http.post(`${environment.API_URL}/reward/list-reward`, {}).subscribe(async (response: any) => {
      // console.log(response.reward);
      this.list = response.reward

      this.list.map(async (item: any) => {
        let url = item.img
        if (url) {
          const status = await this.api.checkImageExists(`${environment.API_URL}${url.replace('src', '')}`)
          if (status === 500 || status === 404) item.img = null;
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

  sum_quantity(item: any) {
    let sum = 0;
    item.RedeemReward.forEach((item: any) => {
      if (item.quantity) sum += item.quantity
    })
    return sum;
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
      if ((this.search == '' || item.reward_name.toLocaleLowerCase().indexOf(this.search.toLocaleLowerCase()) != -1)) {
        n++
        return item;
      }
    }).slice(start, end);
    this.last_page = Math.ceil(n / end);
    console.log('test');
  }

  updatePage(page_no: number) {
    // alert(page_no)
    if (page_no >= 0 && page_no < this.last_page) {
      this.page_no = page_no;
    }
    this.list_Filter()
  }

}
