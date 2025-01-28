import { Component, OnInit, OnDestroy } from '@angular/core';
import { RouterOutlet, Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent implements OnInit {
  title = 'econmassapp';
  path = ''
  constructor(public router: Router, private route: ActivatedRoute) {

  }
  active = 'background-color: #00ADEF;color: #fff;'
  menu: any[] = [];

  ngOnInit() {

  }

  ngAfterContentChecked() {
    if (this.router.url != this.path) {
      this.path = this.router.url
    }
  }

  goToLink(url: string) {
    this.router.navigate([url]).finally(() => {
      this.path = this.router.url
    })
  }
}
