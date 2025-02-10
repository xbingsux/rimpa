import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-reward-update',
  standalone: true,
  imports: [],
  templateUrl: './reward-update.component.html',
  styleUrl: './reward-update.component.scss'
})
export class RewardUpdateComponent {

  constructor(public router: Router) { }

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

}
