import { HttpClient } from '@angular/common/http';
import { Component, ElementRef, Input, OnInit, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { DatePipe, NgFor, NgIf } from '@angular/common';
import { ApiService } from '../api/api.service';
import { FormsModule } from '@angular/forms';
import { QRCodeModule } from 'angularx-qrcode';
import html2canvasLib from 'html2canvas';

@Component({
  selector: 'app-event-management',
  standalone: true,
  imports: [NgFor, DatePipe, NgIf, FormsModule, QRCodeModule],
  templateUrl: './event-management.component.html',
  styleUrl: './event-management.component.scss'
})
export class EventManagementComponent implements OnInit {

  @Input() routeScreen = false

  constructor(private router: Router, private http: HttpClient, public api: ApiService) { }
  tz = environment.timeZone;
  list: any[] = []
  qrcode = ''
  event_name = ''
  delete_id: number | null = null;

  ngOnInit(): void {
    this.http.get(`${environment.API_URL}/list-event`, {}).subscribe(async (response: any) => {
      console.log(response.event);
      this.list = response.event;
      this.list_Filter()
    }, error => {
      console.error('Error:', error);
    });
  }

  // The text/data that the QR code will encode
  qrText: string = '';

  @ViewChild('qrContainer') qrContainer!: ElementRef;

  async downloadQRCode(): Promise<void> {
    try {
      const canvas = await html2canvasLib(this.qrContainer.nativeElement);
      const imageData = canvas.toDataURL('image/png');
      const downloadLink = document.createElement('a');
      downloadLink.href = imageData;
      downloadLink.download = `${this.event_name}.png`;
      downloadLink.click();
    } catch (error: any) {
      console.error('Error capturing QR Code:', error);
    }
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

  deleteEvent() {
    this.http.post(`${environment.API_URL}/delete-event`, { id: this.delete_id }).subscribe(async (response: any) => {
      // console.log(response);
      alert('ลบข้อมูลสำเร็จ')
      this.ngOnInit()
      this.delete_id = null;
    }, error => {
      alert('ไม่สามารถลบข้อมูลได้')
      console.error('Error:', error);
    });
  }

}

