import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http'
import { ActivatedRouteSnapshot, CanActivate, Router, RouterStateSnapshot, UrlTree } from '@angular/router';
import { Observable, config, map, take } from 'rxjs';
import { environment } from '../../environments/environment'

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  api_url = environment.API_URL;
  constructor(private router: Router, private http: HttpClient) { }

  async login(email: string, password: string) {
    try {
      const response: any = await this.http.post(`${this.api_url}/auth/login`, { email, password }).toPromise();

      if (response.role === 'admin') {
        localStorage.setItem('token', response.token);
        this.router.navigate(['admin/dashboard']);
      } else {
        return 'คุณไม่มีสิทธิ์ในการเข้าถึงข้อมูล';
      }

      // console.log('login', response);
      return response;
    } catch (error) {
      console.error('Login failed', error);
      return 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
    }
  }

  async logout() {
    try {
      const response: any = await this.http.post(`${this.api_url}/auth/logout`, {}).toPromise();
      localStorage.removeItem('token')
      this.router.navigate(['login'])
      return response;
    } catch (error) {
      console.error('Logout failed', error);
      return 'ไม่สามารถล็อคเอาท์ได้';
    }
  }


  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean | UrlTree | Observable<boolean | UrlTree> | Promise<boolean | UrlTree> {
    const isAuthenticated = !!localStorage.getItem('token');

    if (!isAuthenticated) {
      if (route.url.toString() != 'login') this.router.navigate(['/login']);
    } else {
      if (route.url.toString() == 'login') this.router.navigate(['admin/dashboard'])
    }
    return true;
  }
}