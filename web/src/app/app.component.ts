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
  title = 'rimpaapp';

  ngOnInit() {
  }

}
