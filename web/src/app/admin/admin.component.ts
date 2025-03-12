import { NgFor, NgIf } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { environment } from '../../environments/environment'
import { ApiService } from '../api/api.service';
import { AuthGuard } from '../service/auth-guard.service';

@Component({
  selector: 'app-admin',
  standalone: true,
  imports: [RouterModule, NgFor, NgIf],
  templateUrl: './admin.component.html',
  styleUrl: './admin.component.scss'
})
export class AdminComponent implements OnInit {

  title = 'admin';
  path = ''

  img_url: string | null = null;
  username = ''
  role = ''

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

  working = false;
  barActive = true
  butt = 'right:37px'

  animation(bar: HTMLElement) {
    this.working = true;
    if (this.barActive) {
      bar.classList.add('expand')
      bar.classList.remove('minimize')
    } else {
      bar.classList.add('minimize')
      bar.classList.remove('expand')
    }
    this.butt = 'right:37px'
    setTimeout(() => {
      if (!this.barActive) {
        this.butt = 'right:37px'
      } else {
        this.butt = 'left:50%;transform:translate(-50%,0)'
      }
      this.working = false;
    }, 700)

    setTimeout(() => {
      this.barActive = !this.barActive
    }, this.barActive ? 200 : 350)
  }

  constructor(
    private router: Router, private route: ActivatedRoute,
    private http: HttpClient, public api: ApiService,
    private auth: AuthGuard
  ) {

  }

  active = 'background-color: #1c1c1c;color: #fff;'//1093ED

  ngOnInit() {
    this.http.get(`${environment.API_URL}/auth/profileMe`, {}).subscribe(async (respone: any) => {
      // console.log(respone.profile);
      let profile = respone.profile
      this.username = profile.profile_name;
      this.role = profile.user.role.role_name;

      const url = `${environment.API_URL}${profile.profile_img.replace('src', '')}`;
      const img_status = await this.api.checkImageExists(url)

      if (img_status == 200) this.img_url = url

    })
  }

  ngAfterContentChecked() {
    if (this.router.url != this.path) {
      this.path = this.router.url
    }
  }

  isUrl(url: string, tags_url: string[]) {
    return tags_url.some((tag: string) => url.indexOf(tag) != -1)
  }

  logout() {
    const logout = this.auth.logout()
    console.log(logout);
    location.reload()
  }
}
