import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { DatePipe, NgFor } from '@angular/common';
import { ApiService } from '../api/api.service';

@Component({
  selector: 'app-event-management',
  standalone: true,
  imports: [NgFor, DatePipe],
  templateUrl: './event-management.component.html',
  styleUrl: './event-management.component.scss'
})
export class EventManagementComponent implements OnInit {

  constructor(private router: Router, private http: HttpClient, public api: ApiService) { }
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

}
