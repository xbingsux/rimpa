import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms'
import { AuthGuard } from '../service/auth-guard.service'
import { Router } from '@angular/router';
import { ApiService } from '../api/api.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent implements OnInit {

  keep_me = false
  constructor(private auth: AuthGuard, private router: Router, public api: ApiService) { }
  ngOnInit(): void {
    if (localStorage.getItem('email')) {
      this.login.email = String(localStorage.getItem('email'))
      this.keep_me = true;
    } else {
      this.login.email = ''
      this.login.password = ''
    }
  }

  async AuthLogin() {
    if (this.keep_me) {
      localStorage.setItem('email', this.login.email)
    } else {
      localStorage.removeItem('email')
    }

    let login = await this.auth.login(this.login.email, this.login.password);
    if (typeof login == 'string') {
      alert(login)
    } else if (typeof login == 'object') {
      login.subscribe((item: any) => {
        console.log('test');
        console.log('login', item);
      })

    }
  }

  login: Login = new Login();
}
class Login {
  email = '';
  password = '';
}