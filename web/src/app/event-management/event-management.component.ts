import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-event-management',
  standalone: true,
  imports: [],
  templateUrl: './event-management.component.html',
  styleUrl: './event-management.component.scss'
})
export class EventManagementComponent {

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
