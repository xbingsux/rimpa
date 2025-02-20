import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {

  constructor(private router: Router, private http: HttpClient) { }

  checkImageExists(url: string): Promise<number> {
    return new Promise((resolve, reject) => {
      this.http.head(url, { observe: 'response' })
        .subscribe({
          next: (response) => resolve(response.status), // คืนค่า 200, 404
          error: (error) => resolve(error.status || 500) // ถ้ามี Error คืนค่า 404 หรือ 500
        });
    })
  }

  async getApi(url: string, data: any): Promise<any> {
    try {
      return await firstValueFrom(this.http.get(url, data));
    } catch (error) {
      throw error;
    }
  }

  async postApi(url: string, data: any): Promise<any> {
    try {
      return await firstValueFrom(this.http.post(url, data));
    } catch (error) {
      throw error;
    }
  }

  goToLink(url: string) {
    this.router.navigate([`${url}`]).finally(() => {
      this.router.url
    })
  }

  toEdit(url: string, key: string) {
    this.router.navigate([`${url}/${key}`])
  }

  toDelete() {

  }

}
