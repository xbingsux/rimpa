import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { DatePipe, NgFor } from '@angular/common';

@Component({
  selector: 'app-event-management',
  standalone: true,
  imports: [NgFor, DatePipe],
  templateUrl: './event-management.component.html',
  styleUrl: './event-management.component.scss'
})
export class EventManagementComponent implements OnInit {

  constructor(private router: Router, private http: HttpClient) { }
  tz = environment.timeZone;
  list: any[] = []
  ngOnInit(): void {
    this.http.post(`${environment.API_URL}/event/list-event`, {}).subscribe(async (response: any) => {
      // console.log(response.event);
      this.list = response.event
    }, error => {
      console.error('Error:', error);
    });
  }

  goToLink(url: string) {
    this.router.navigate([`${url}`]).finally(() => {
      this.router.url
    })
  }

  toEdit(url: string, key: string) {
    this.router.navigate([`${url}/${key}`])
  }

  toDelete() {

  }
}
