import { Component, Injectable, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http'
import { TestApiService } from './test-api.service'
@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss'
})
@Injectable({
  providedIn: 'root'
})
export class DashboardComponent implements OnInit {

  constructor(private http: HttpClient, private api: TestApiService) {

  }
  ngOnInit(): void {
    this.api.test()
  }

  test() {
    this.api.test()
  }
}
