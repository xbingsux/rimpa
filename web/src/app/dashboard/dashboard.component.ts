import { Component, Injectable, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http'
import { TestApiService } from './test-api.service'
import { NgFor, NgIf } from '@angular/common';
import { EventManagementComponent } from "../event-management/event-management.component";
import { RewardManagementComponent } from "../reward-management/reward-management.component";
@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [NgIf, NgFor, EventManagementComponent, RewardManagementComponent],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss'
})
@Injectable({
  providedIn: 'root'
})
export class DashboardComponent implements OnInit {

  dashboard_total: any[] = [
    {
      title: 'Total Events',
      count: 200
    }, {
      title: 'Total Attendees',
      count: 200
    }, {
      title: 'Total Reward',
      count: 200
    }, {
      title: 'Total User',
      count: 200
    },
  ]

  path: String = 'event'

  constructor(private http: HttpClient, private api: TestApiService) {

  }
  ngOnInit(): void {
    this.api.test()
  }

  setPath(path: String) {
    this.path = path;
  }
}
