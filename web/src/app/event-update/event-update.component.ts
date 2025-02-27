import { DatePipe, NgFor, NgIf } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Component, input, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { environment } from '../../environments/environment';
import { ApiService } from '../api/api.service';

@Component({
  selector: 'app-event-update',
  standalone: true,
  imports: [FormsModule, NgIf, NgFor],
  templateUrl: './event-update.component.html',
  styleUrl: './event-update.component.scss'
})
export class EventUpdateComponent implements OnInit {

  constructor(private route: ActivatedRoute, private router: Router, private http: HttpClient, public api: ApiService) { }

  ngOnInit(): void {
    this.route.paramMap.subscribe((param) => {
      // console.log(param.get('id'));
      if (param.get('id')) {
        this.data.id = Number(param.get('id'))
        this.http.post(`${environment.API_URL}/get-event`, { id: this.data.id }).subscribe(async (item: any) => {
          // console.log(item);

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

          event.SubEvent[0].img.filter(async (item: any) => {
            let path = `${environment.API_URL}${item.path.replace('src', '')}`;
            let name = path.split(/[/\\]/).pop();
            path = await this.api.checkImageExists(path) != 500 ? path : ''

            this.data.list_img.push(new Img({ id: item.id, path: item.path.replace('src', ''), realpath: path, name }))
            this.list_file = this.data.list_img;
          })
        })
      }
    })
  }

  img_file: File | null = null;
  list_file: any[] = [];

  onFileChange(event: Event, n: number) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        const path = reader.result as string;
        this.list_file[n] = new Img({ id: this.list_file[n].id, file, path, realpath: path });
      };
      reader.readAsDataURL(file);
    }
  }

  onFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    const file = input.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        const path = reader.result as string;
        this.list_file.push(new Img({ file, path, realpath: path }))

        input.value = ''
      };
      reader.readAsDataURL(file);
    }
  }

  deleteFile(n: number) {
    this.list_file.splice(n, 1);
  }

  data: AddEvent = new AddEvent()

  upload_img(file: File): Promise<string | null> {
    return new Promise((resolve, reject) => {
      let formData = new FormData();
      formData.append('file', file);
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
    });
  }

  async submit() {
    // console.log(this.data.list_img);
    // this.data.list_img 
    const imgs = await Promise.all(
      this.list_file.map(async (item, index) => {
        if (item.file) {
          const imgPath = await this.upload_img(item.file);
          // console.log("🚀 Image Path:", imgPath);
          if (imgPath != null) {
            item.path = imgPath;
          }
        }
        return { index, id: item.id, path: item.path };
      })
    ).then(results => results.sort((a, b) => a.index - b.index));

    // console.log(imgs);

    // console.log(this.data.list_img);


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
      event_img: imgs
    }).subscribe(async (response: any) => {
      // console.log(response);
      if (response.status == 'success') this.router.navigate(['/admin/event'])
    }, error => {
      console.error('Error:', error);
    });
  }
}
class Img {
  id: number
  path: string
  realpath: string
  name: string
  sub_event_id = 0
  file: File | null

  constructor({ id = 0, path = '', realpath = '', name = '', file = null }: Partial<Img> = {}) {
    this.id = id
    this.path = path
    this.realpath = realpath
    this.name = name
    this.file = file
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