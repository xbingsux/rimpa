import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { environment } from '../../environments/environment'
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-new-password',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './new-password.component.html',
  styleUrl: './new-password.component.scss'
})
export class NewPasswordComponent implements OnInit {
  constructor(private route: ActivatedRoute, private router: Router, private http: HttpClient) { }

  token = ''
  newPassword = ''
  confirmPassword = ''

  ngOnInit(): void {
    this.route.queryParams.subscribe((item: any) => {
      this.token = item.token
    })
  }

  resetPassword() {
    if (this.newPassword != this.confirmPassword && this.newPassword == '') return

    this.http.post(`${environment.API_URL}/auth/reset-password`, {
      token: this.token,
      new_password: this.newPassword
    }).subscribe((response: any) => {
      if (response.status == 'success') {
        this.router.navigate(['/login'])
      }
    })
  }

  goToLink(url: string) {
    this.router.navigate([`${url}`]).finally(() => {
      this.router.url
    })
  }

}
