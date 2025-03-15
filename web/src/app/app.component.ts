import { Component, OnInit } from '@angular/core';
import { RouterOutlet, Router, ActivatedRoute } from '@angular/router';
import { ApiService } from './api/api.service';
import { NgClass, NgFor, NgIf } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NgIf, NgFor, NgClass],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent implements OnInit {
  title = 'rimpaapp';

  constructor(private router: Router, private route: ActivatedRoute, public api: ApiService) { }

  ngOnInit() {
  }

  alerting = false;
  test(index: number) {
    if (this.api.listAlert.length != 0) {
      if (this.api.listAlert[index].status == 'send') {
        this.alerting = true;
        console.log(index);
        this.api.listAlert[index].status = 'reading'
        setTimeout(() => {
          this.api.listAlert[index].status = 'read'
          // this.api.listAlert.shift()
          if (this.api.listAlert.every(item => item.status != 'send' && item.status != 'reading')) {
            setTimeout(() => {
              if (this.api.listAlert.every(item => item.status != 'send' && item.status != 'reading')) this.api.listAlert = []
            }, 700)
          }
        }, 2000);
      }
    } else {
      return false;
    }
    return true;
  }

}
