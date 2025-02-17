import { NgFor, NgIf } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { environment } from '../../environments/environment'
import { ApiService } from '../api/api.service';

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

  constructor(private router: Router, private route: ActivatedRoute, private http: HttpClient, public api: ApiService) { }
  active = 'background-color: #fff;color: #1093ED;'

  ngOnInit() {
    this.http.post(`${environment.API_URL}/auth/profileMe`, {}).subscribe(async (respone: any) => {
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

  logout() {
    localStorage.removeItem('token')
    this.router.navigate(['login'])
  }

  isUrl(url: string, tags_url: string[]) {
    return tags_url.some((tag: string) => url.indexOf(tag) != -1)
  }
}
