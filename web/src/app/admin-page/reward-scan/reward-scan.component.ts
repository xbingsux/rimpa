import { Component } from '@angular/core';
import { ApiService } from '../../api/api.service';
import { AlertType } from '../../model/alert';

@Component({
  selector: 'app-reward-scan',
  standalone: true,
  imports: [],
  templateUrl: './reward-scan.component.html',
  styleUrl: './reward-scan.component.scss'
})
export class RewardScanComponent {

  constructor(
    // private router: Router, private route: ActivatedRoute, 
    public api: ApiService
  ) { }
  test() {
    this.api.listAlert.push(new AlertType('success', ``))
  }
}
