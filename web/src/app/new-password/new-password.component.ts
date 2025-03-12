import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { environment } from '../../environments/environment'
import { FormsModule } from '@angular/forms';
import { ApiService } from '../api/api.service';

@Component({
  selector: 'app-new-password',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './new-password.component.html',
  styleUrl: './new-password.component.scss'
})
export class NewPasswordComponent implements OnInit {
  constructor(private route: ActivatedRoute, private router: Router, private http: HttpClient, public api: ApiService) { }

  token = ''
  newPassword = ''
  confirmPassword = ''

  ngOnInit(): void {
    this.route.queryParams.subscribe((item: any) => {
      this.token = item.token
    })
  }

  active = false;
  resetPassword() {
    this.active = true

    if (this.newPassword == this.confirmPassword && this.newPassword.trim() != '') {
      this.http.put(`${environment.API_URL}/auth/reset-password`, {
        token: this.token,
        new_password: this.newPassword
      }).subscribe((response: any) => {
        if (response.status == 'success') {
          this.router.navigate(['/login'])
        }
      })
    } else {
      this.active = false
      alert('กรุณากรอกรหัสผ่าน')
    }
  }
}
