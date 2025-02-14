import { NgIf } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-reward-update',
  standalone: true,
  imports: [NgIf, FormsModule],
  templateUrl: './reward-update.component.html',
  styleUrl: './reward-update.component.scss'
})
export class RewardUpdateComponent {

  constructor(private router: Router, private http: HttpClient) { }

  img_path = ''//base64

  onFileSelected(event: Event) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        this.img_path = reader.result as string;
      };
      reader.readAsDataURL(file);
    }
  }

  goToLink(url: string) {
    this.router.navigate([`${url}`]).finally(() => {
      this.router.url
    })
  }

  data: Reward = new Reward()

  submit() {
    this.http.post(`${environment.API_URL}/reward/update-reward`, {
      id: this.data.id,
      reward_name: this.data.reward_name,
      description: this.data.description,
      startDate: new Date(this.data.startDate),
      endDate: new Date(this.data.endDate),
      img: this.data.img,
      stock: +this.data.stock,
      cost: +this.data.cost
    }).subscribe(async (response: any) => {
      console.log(response);
      if (response.status == 'success') this.router.navigate(['/admin/reward'])
    }, error => {
      console.error('Error:', error);
    });
  }
}

class Reward {
  id = 0
  reward_name = ''
  description = ''
  img = ''
  startDate = ''
  endDate = ''
  stock: number = 0
  cost: number = 0
}