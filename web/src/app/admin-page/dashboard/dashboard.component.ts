import { Component, Injectable, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http'
import { NgFor, NgIf } from '@angular/common';
import { EventManagementComponent } from "../event-management/event-management.component";
import { RewardManagementComponent } from "../reward-management/reward-management.component";
import { environment } from '../../../environments/environment';
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
  repeatTimes = Array(4).fill(0)
  dashboard_total: any[] = []

  path: String = 'event'

  constructor(private http: HttpClient) {

  }
  ngOnInit(): void {
    this.http.get(`${environment.API_URL}/dashboard`, {}).subscribe(async (response: any) => {
      this.dashboard_total = response.dashboard
    }, error => {
      console.error('Error:', error);
    });
  }

  setPath(path: String) {
    this.path = path;
  }
}
