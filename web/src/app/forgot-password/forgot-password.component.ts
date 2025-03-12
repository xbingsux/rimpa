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

  active = false
  counter = 0;
  reset_password(event: Event) {
    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    let e = emailPattern.test(this.email);
    if (e) {
      let bt = event.target as HTMLInputElement;
      this.active = true;

      bt.disabled = true;
      let count = 60
      const interval = setInterval(() => {
        this.counter++;
        bt.value = `You can resend in ${count - this.counter}s`
        if (this.counter >= count) {
          bt.disabled = false;
          this.counter = 0;
          bt.value = 'Send again';
          clearInterval(interval);
        }
      }, 1000);

      this.http.post(`${environment.API_URL}/auth/forgot-password`, { email: this.email }).subscribe((response: any) => {
        // console.log(response);
      })
    } else {
      alert('กรุณาระบุ email ให้ถูกต้อง')
    }


  }
}
