import { DatePipe, NgIf } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { environment } from '../../environments/environment';

@Component({
  selector: 'app-event-update',
  standalone: true,
  imports: [FormsModule, NgIf],
  templateUrl: './event-update.component.html',
  styleUrl: './event-update.component.scss'
})
export class EventUpdateComponent implements OnInit {

  constructor(private route: ActivatedRoute, private router: Router, private http: HttpClient) { }

  ngOnInit(): void {
    this.route.paramMap.subscribe((param) => {
      console.log(param.get('id'));

      if (param.get('id')) {
        this.data.id = Number(param.get('id'))
        this.http.post(`${environment.API_URL}/event/get-event`, { id: this.data.id }).subscribe((item: any) => {
          let event = item.event;
          this.data.id = event.id;
          this.data.sub_event_id = event.SubEvent[0].id
          this.data.title = event.title;
          this.data.description = event.description;
          this.data.max_attendees = event.max_attendees;
          this.data.map = event.SubEvent[0].map
          this.data.startDate = new Date(event.startDate).toISOString().slice(0, 16)
          this.data.endDate = new Date(event.endDate).toISOString().slice(0, 16)
          this.data.point = event.SubEvent[0].point
        })
      }
    })
  }

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
  data: AddEvent = new AddEvent()

  submit() {
    this.http.post(`${environment.API_URL}/event/update-event`, {
      event_id: this.data.id,
      sub_event_id: this.data.sub_event_id,
      title: this.data.title,
      description: this.data.description,
      max_attendees: +this.data.max_attendees,
      map: this.data.map,
      releaseDate: this.data.releaseDate ? new Date(this.data.releaseDate) : null,
      startDate: new Date(this.data.startDate),
      endDate: new Date(this.data.endDate),
      point: +this.data.point,
    }).subscribe(async (response: any) => {
      console.log(response);
      if (response.status == 'success') this.router.navigate(['/admin/event'])
    }, error => {
      console.error('Error:', error);
    });
  }

}
class AddEvent {
  id: number = 0
  sub_event_id: number = 0
  title = ''
  description = ''
  max_attendees: number = 0
  map = ''
  releaseDate = null
  startDate = ''
  endDate = ''
  point: number = 0
}