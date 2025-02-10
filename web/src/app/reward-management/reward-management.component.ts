import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-reward-management',
  standalone: true,
  imports: [],
  templateUrl: './reward-management.component.html',
  styleUrl: './reward-management.component.scss'
})
export class RewardManagementComponent {

  constructor(public router: Router) {

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
