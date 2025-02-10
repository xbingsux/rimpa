import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class TestApiService {

  constructor(private http: HttpClient) { }
  test() {
    return this.http.post(`${environment.API_URL}/auth/test`, {}).subscribe((response) => {
      console.log('Protected Data:', response);
    }, error => {
      console.error('Error:', error);
    });
  }
}
