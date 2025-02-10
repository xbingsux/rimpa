import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms'
import { AuthGuard } from '../service/auth-guard.service'
@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent implements OnInit {

  keep_me = false
  constructor(private auth: AuthGuard) {

  }
  ngOnInit(): void {
    if (localStorage.getItem('email')) {
      this.login.email = String(localStorage.getItem('email'))
      this.keep_me = true;
    }
  }

  AuthLogin() {
    if (this.keep_me) {
      localStorage.setItem('email', this.login.email)
    } else {
      localStorage.removeItem('email')
    }

    this.auth.login(this.login.email, this.login.password).subscribe((item) => { console.log(item); })
  }

  login: Login = new Login();
}
class Login {
  email = '';
  password = '';
}