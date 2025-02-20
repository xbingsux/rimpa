import { HttpClient } from '@angular/common/http';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment'
import { ApiService } from '../api/api.service';

@Component({
  selector: 'app-forgot-password',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './forgot-password.component.html',
  styleUrl: './forgot-password.component.scss'
})
export class ForgotPasswordComponent {

  constructor(private router: Router, private http: HttpClient, public api: ApiService) { }
  email = ''

  reset_password() {
    this.http.post(`${environment.API_URL}/auth/forgot-password`, { email: this.email }).subscribe((response: any) => {
      console.log(response);
    })
  }
}
