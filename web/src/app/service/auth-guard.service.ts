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

  login(email: string, password: string) {
    let response = this.http.post(`${this.api_url}/auth/login`, { email, password })
    response.subscribe((item: any) => {
      localStorage.setItem('token', item.token)
      this.router.navigate(['admin/dashboard']);
    })
    return response
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