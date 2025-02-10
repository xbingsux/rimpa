import { NgFor } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';

@Component({
  selector: 'app-admin',
  standalone: true,
  imports: [RouterModule, NgFor],
  templateUrl: './admin.component.html',
  styleUrl: './admin.component.scss'
})
export class AdminComponent implements OnInit {

  title = 'admin';
  path = ''
  menu: any[] = [
    {
      title: 'Dashboard',
      path: `/${this.title}/dashboard`,
      icon: 'dashboard.svg'
    },
    {
      title: 'Event Management',
      path: `/${this.title}/event`,
      icon: 'calendar.svg'
    },
    {
      title: 'Banner Management',
      path: `/${this.title}/banner`,
      icon: 'notification.svg'
    },
    {
      title: 'Reward Management',
      path: `/${this.title}/reward`,
      icon: 'cup.svg'
    },
    {
      title: 'User Management',
      path: `/${this.title}/users`,
      icon: 'users.svg'
    }
  ]


  constructor(public router: Router, private route: ActivatedRoute) {

  }
  active = 'background-color: #1C1C1C;color: #fff;'

  ngOnInit() {

  }

  ngAfterContentChecked() {
    if (this.router.url != this.path) {
      this.path = this.router.url
    }
  }

  goToLink(url: string) {
    this.router.navigate([`${url}`]).finally(() => {
      this.path = this.router.url
    })
  }

  logout() {
    localStorage.removeItem('token')
    this.router.navigate(['login'])
  }
}
