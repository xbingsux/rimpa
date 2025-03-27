import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../../environments/environment';
import { DatePipe, NgFor, NgIf } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { ApiService } from '../../api/api.service';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-banner-management',
  standalone: true,
  imports: [DatePipe, NgFor, NgIf, FormsModule],
  templateUrl: './banner-management.component.html',
  styleUrl: './banner-management.component.scss'
})
export class BannerManagementComponent {

  constructor(private router: Router, private http: HttpClient, public api: ApiService) { }
  tz = environment.timeZone;
  list: any[] = []
  ngOnInit(): void {
    this.http.get(`${environment.API_URL}/list-banner`, {}).subscribe(async (response: any) => {
      // console.log(response.banner);
      this.list = response.banner

      this.list.map(async (item: any) => {
        let url = item.path
        if (url) {
          const status = await this.api.checkImageExists(`${environment.API_URL}${url.replace('src', '')}`)
          if (status === 500 || status === 404) item.path = null;
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
  data_size = 0;
  readonly max_page = 3
  readonly max_item = 10
  data: any[] = []
  list_Filter(): any {
    let n = 0;
    let start = this.page_no * this.max_item;
    let end = start + this.max_item;
    this.data = this.list.filter((item) => {
      if ((this.search == '' || item.title.toLocaleLowerCase().indexOf(this.search.toLocaleLowerCase()) != -1)) {
        n++
        return item;
      }
    }).slice(start, end);
    this.data_size = Math.ceil(n / this.max_item);
    this.last_page = Math.ceil(n / end);
  }

  getPageArray(): number[] {
    const size = this.data_size > this.max_page ? this.max_page : this.data_size;
    let arr: number[] = []
    for (let i = 0; i < size; i++) {
      arr.push(this.page(this.page_no, i))
    }
    return arr
  }

  page(page: number, n: number): number {
    // n++;
    let p = page // หน้าปัจจุบัน
    let s = this.data_size //หน้าทั้งหมดที่มี
    let m = this.max_page //จำนวนหน้าที่แสดง
    //n ตำแหน่งจาก n จนถึง max_page
    if (s < m) {
      return n
    } else if (s - p < m) {
      return (s - m) + n
    }
    return p + n
  }

  updatePage(n: number) {
    let page_no = n;
    if (page_no >= 0 && page_no < this.data_size) {
      this.page_no = page_no;
    }
    this.list_Filter()
  }

  delete_id: number | null = null;
  deleteBanner() {
    this.http.post(`${environment.API_URL}/delete-banner`, { id: this.delete_id }).subscribe(async (response: any) => {
      // console.log(response);
      this.api.addAlert('success', 'ลบข้อมูลสำเร็จ');
      // alert('ลบข้อมูลสำเร็จ')
      this.ngOnInit()
      this.delete_id = null;
    }, error => {
      this.api.addAlert('unsuccessful', 'ลบข้อมูลไม่สำเร็จ');
      // alert('ไม่สามารถลบข้อมูลได้')
      console.error('Error:', error);
    });
  }

  timeFrame(sDate: Date, eDate: Date): boolean {
    const now = new Date();
    const startDate = new Date(sDate);
    const endDate = new Date(new Date(eDate).getTime() + 24 * 60 * 60 * 1000);

    return now.getTime() >= startDate.getTime() && now.getTime() <= endDate.getTime();
  }

}
