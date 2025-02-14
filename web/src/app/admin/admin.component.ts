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
      icon: 'dashboard.svg',
      tags: [
        `/${this.title}/dashboard`,
      ]
    },
    {
      title: 'Event Management',
      path: `/${this.title}/event`,
      icon: 'calendar.svg',
      tags: [
        `/${this.title}/event`,
        `/${this.title}/event-update`
      ]
    },
    {
      title: 'Banner Management',
      path: `/${this.title}/banner`,
      icon: 'notification.svg',
      tags: [
        `/${this.title}/banner`,
        `/${this.title}/banner-update`
      ]
    },
    {
      title: 'Reward Management',
      path: `/${this.title}/reward`,
      icon: 'cup.svg',
      tags: [
        `/${this.title}/reward`,
        `/${this.title}/reward-update`
      ]
    },
    {
      title: 'User Management',
      path: `/${this.title}/users`,
      icon: 'users.svg',
      tags: [
        `/${this.title}/users`,
        `/${this.title}/user-update`
      ]
    }
  ]


  constructor(private router: Router, private route: ActivatedRoute) {

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

  isUrl(url: string, tags_url: string[]) {
    return tags_url.some((tag: string) => url.indexOf(tag) != -1)
  }
}
