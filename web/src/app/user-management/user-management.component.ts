import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-user-management',
  standalone: true,
  imports: [],
  templateUrl: './user-management.component.html',
  styleUrl: './user-management.component.scss'
})
export class UserManagementComponent {

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
