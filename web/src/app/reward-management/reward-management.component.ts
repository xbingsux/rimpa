import { HttpClient } from '@angular/common/http';
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { DatePipe, NgFor } from '@angular/common';

@Component({
  selector: 'app-reward-management',
  standalone: true,
  imports: [NgFor, DatePipe],
  templateUrl: './reward-management.component.html',
  styleUrl: './reward-management.component.scss'
})
export class RewardManagementComponent {

  constructor(private router: Router, private http: HttpClient) { }
  tz = environment.timeZone;
  list: any[] = []
  ngOnInit(): void {
    this.http.post(`${environment.API_URL}/reward/list-reward`, {}).subscribe(async (response: any) => {
      console.log(response.reward);
      this.list = response.reward
    }, error => {
      console.error('Error:', error);
    });
  }

  sum_quantity(item: any) {
    let sum = 0;
    item.RedeemReward.forEach((item: any) => {
      if (item.quantity) sum += item.quantity
    })
    return sum;
  }

  goToLink(url: string) {
    this.router.navigate([`${url}`]).finally(() => {
      this.router.url
    })
  }


  toEdit() {

  }

  toDelete() {

  }
}
