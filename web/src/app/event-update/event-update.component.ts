import { DatePipe, NgIf } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { ApiService } from '../api/api.service';

@Component({
  selector: 'app-event-update',
  standalone: true,
  imports: [FormsModule, NgIf],
  templateUrl: './event-update.component.html',
  styleUrl: './event-update.component.scss'
})
export class EventUpdateComponent implements OnInit {

  constructor(private route: ActivatedRoute, private router: Router, private http: HttpClient, public api: ApiService) { }

  ngOnInit(): void {
    this.route.paramMap.subscribe((param) => {
      console.log(param.get('id'));

      if (param.get('id')) {
        this.data.id = Number(param.get('id'))
        this.http.post(`${environment.API_URL}/get-event`, { id: this.data.id }).subscribe(async (item: any) => {
          console.log(item);

          let event = item.event;
          this.data.id = event.id;
          this.data.sub_event_id = event.SubEvent[0].id
          this.data.title = event.title;
          this.data.description = event.description;
          this.data.max_attendees = event.max_attendees;
          this.data.map = event.SubEvent[0].map
          this.data.startDate = new Date(event.startDate).toISOString().slice(0, 16)
          this.data.endDate = new Date(event.endDate).toISOString().slice(0, 16)
          this.data.point = event.SubEvent[0].point;

          if (event.SubEvent[0].img.length != 0) {
            this.data.list_img = event.SubEvent[0].img;
            let path = `${environment.API_URL}${event.SubEvent[0].img[0].path.replace('src', '')}`;
            path = await this.api.checkImageExists(path) != 500 ? path : ''
            this.img_path = path;
            // console.log(this.data.list_img);
            // this.data.list_img[0].id = event.SubEvent[0].img[0].id
            // this.data.list_img[0].path = event.SubEvent[0].img[0].paths
          }
        })
      }


    })
  }

  img_path = ''//base64
  img_file: File | null = null;

  onFileSelected(event: Event) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
      this.img_file = file;
      const reader = new FileReader();
      reader.onload = () => {
        this.img_path = reader.result as string;
      };
      reader.readAsDataURL(file);
    }
  }

  data: AddEvent = new AddEvent()

  upload_img(): Promise<string | null> {
    return new Promise((resolve, reject) => {
      let formData = new FormData();
      if (this.img_file) {
        formData.append('file', this.img_file);
        this.http.post(`${environment.API_URL}/upload/event`, formData).subscribe(
          (item: any) => {
            if (item.path) {
              resolve(item.path);
            } else {
              resolve(null);
            }
          },
          (error) => {
            console.error("🚨 Upload Error:", error);
            reject(error);
          }
        );
      } else {
        resolve(null);
      }
    });
  }

  async submit() {
    const imgPath = await this.upload_img();
    console.log("🚀 Image Path:", imgPath);
    if (imgPath != null) {
      if (this.data.list_img.length != 0) {
        this.data.list_img[0].path = imgPath;
      } else {
        this.data.list_img[0] = new Img(0, imgPath)
      }
    }


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
      event_img: this.data.list_img
    }).subscribe(async (response: any) => {
      console.log(response);
      if (response.status == 'success') this.router.navigate(['/admin/event'])
    }, error => {
      console.error('Error:', error);
    });
  }

}
class Img {
  id = 0
  path = ''
  sub_event_id = 0
  constructor(id: number, path: string) {
    this.id = id
    this.path = path
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
  list_img: Img[] = []
}