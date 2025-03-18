import { DatePipe, NgFor, NgIf } from '@angular/common';
import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { environment } from '../../environments/environment';
import { FormsModule } from '@angular/forms';
import { BsDatepickerDirective, BsDatepickerModule } from 'ngx-bootstrap/datepicker';
import { TimepickerModule } from 'ngx-bootstrap/timepicker';

@Component({
  selector: 'app-date-picker',
  standalone: true,
  imports: [DatePipe, NgFor, NgIf, FormsModule, BsDatepickerModule, TimepickerModule],
  templateUrl: './date-picker.component.html',
  styleUrl: './date-picker.component.scss'
})
export class DatePickerComponent implements OnInit {
  @ViewChild('bsDatepicker', { static: false }) datepicker!: BsDatepickerDirective;
  @Input() itemId = 'date-picker'
  @Input() date = new Date()
  @Output() dateChange: EventEmitter<Date> = new EventEmitter<Date>();
  selectedDate: Date = new Date(); // กำหนดค่าเริ่มต้นของ DatePicker
  selectedTime: Date = new Date(); // กำหนดค่าเริ่มต้นของ TimePicker

  parts = 'dd/MM/YYYY HH:mm'.split(/\W+/);
  tz: string = 'UTC';
  tz_num = Number(environment.timeZone.replace(/\D+/, '')) * 60
  time_gap = ((this.tz_num + this.date.getTimezoneOffset()) / -60) * 60 * 60 * 1000

  showDate = false
  bsConfig = {
    isAnimated: true,
    adaptivePosition: true,
    showWeekNumbers: false
  };

  updateDate() {
    this.dateChange.emit(this.date); // ส่งค่าออกไปยัง Parent Component
  }

  ngOnInit(): void {
    this.tz = environment.timeZone;
    // this.date = new Date();
    // this.date.setHours(0, 0, 0, 0)
    // console.log(this.item['YYYY']);
    this.setItem()
    this.date = new Date(this.date.getTime() + this.time_gap)
  }

  item: { [key: string]: any } = {}
  setItem() {
    this.item = {
      YYYY: {
        value: this.date.getFullYear(),
        min: 1,
        max: 9999,
        max_length: 4
      },
      d: {
        value: this.date.getDate(),
        min: 1,
        max: 31,
        max_length: 2
      },
      dd: {
        value: String(this.date.getDate()).padStart(2, '0'),
        min: 1,
        max: 31,
        max_length: 2
      },
      M: {
        value: this.date.getMonth() + 1,
        min: 1,
        max: 12,
        max_length: 2
      },
      MM: {
        value: String(this.date.getMonth() + 1).padStart(2, '0'),
        min: 1,
        max: 12,
        max_length: 2
      },
      MMM: this.date.toLocaleString('en-US', { month: 'short' }),
      MMMM: this.date.toLocaleString('en-US', { month: 'long' }),
      y: {
        value: this.date.getFullYear(),
        min: 1,
        max: 9999,
        max_length: 4
      },
      yy: {
        value: String(this.date.getFullYear()).slice(-2),
        min: 1,
        max: 9999,
        max_length: 4
      },
      yyyy: {
        value: this.date.getFullYear(),
        min: 1,
        max: 9999,
        max_length: 4
      },
      h: {
        value: this.date.getHours() % 12 || 12,
        min: 0,
        max: 12,
        max_length: 2
      },
      hh: {
        value: String(this.date.getHours() % 12 || 12).padStart(2, '0'),
        min: 0,
        max: 12,
        max_length: 2
      },
      H: {
        value: this.date.getHours(),
        min: 0,
        max: 23,
        max_length: 2
      },
      HH: {
        value: String(this.date.getHours()).padStart(2, '0'),
        min: 0,
        max: 23,
        max_length: 2
      },
      m: {
        value: this.date.getMinutes(),
        min: 0,
        max: 59,
        max_length: 2
      },
      mm: {
        value: String(this.date.getMinutes()).padStart(2, '0'),
        min: 0,
        max: 59,
        max_length: 2
      },
      s: {
        value: this.date.getSeconds(),
        min: 0,
        max: 59,
        max_length: 2
      },
      ss: {
        value: String(this.date.getSeconds()).padStart(2, '0'),
        min: 0,
        max: 59,
        max_length: 2
      },
      a: this.date.getHours() < 12 ? 'AM' : 'PM',
      z: Intl.DateTimeFormat().resolvedOptions().timeZone,
      Z: new Date().getTimezoneOffset() / -60,
    };
  }

  select: HTMLElement | null = null
  key: string = ''

  selectText(id: string | HTMLElement): void {
    // console.log(this.date);

    let element = null
    if (typeof id == 'string') {
      // console.log(id);

      element = document.getElementById(`${this.itemId}-${id}`) as HTMLElement;
    } else {
      element = id
    }

    // console.log(element);

    const selection = window.getSelection();
    if (this.select != element) {
      this.key = '';
    }
    this.select = element;
    if (selection) {
      const range = document.createRange();
      range.selectNodeContents(element);
      selection.removeAllRanges();
      selection.addRange(range);
    }
  }

  keydownElement(event: KeyboardEvent) {
    // console.log(event.key);
    const number = Number(event.key)
    let select = this.select;
    let tap = (id: string) => {
      id = id.slice(this.itemId.length + 1)

      const index = this.parts.indexOf(id);
      if (index !== -1 && index + 1 < this.parts.length) {
        let path = this.parts[index + 1]
        if (path) {
          event.preventDefault()
          this.selectText(path)
        }
      } else {
        this.key = '';
      }
    }
    if (select) {
      let id = select.id.slice(this.itemId.length + 1)
      if (!isNaN(number) && event.key.trim() != '') {
        this.key += number;
        let item = this.item[id]
        if (item) {
          let max = item.max;
          let max_length = item.max_length;
          item.value = this.key.padStart(max_length, '0')

          if (Number(item.value) > max) {
            item.value = max
          }
          if (this.key.length >= max_length) {
            if (item.value <= 0) item.value = `${item.min}`.padStart(max_length, '0')
            select.innerText = item.value;
            tap(select.id)
          } else {
            select.innerText = item.value;
            this.selectText(select)
          }

          let date = new Date()
          date.setFullYear(+this.item['YYYY'].value, +this.item['MM'].value - 1, +this.item['dd'].value)
          date.setHours(+this.item['HH'].value, +this.item['mm'].value, 0, 0)

          this.date = new Date(date.getTime() + this.time_gap)

          // console.log(date);
          // alert(this.date.toUTCString())
        }
        this.updateDate()
      } else if (event.key === 'Tab') {
        this.endElement()
        tap(select.id)
      } else if (event.key === 'Backspace') {
        select.innerText = select.id
        this.selectText(select)
        this.key = ''
      } else if (event.key.trim() != '') {

      }
    }
  }

  endElement() {
    let select = this.select;
    // console.log(select);
    if (select) {
      let id = select.id.slice(this.itemId.length + 1)
      // console.log(id);

      let item = this.item[id]
      if (item && +item.value <= 0) item.value = `${item.min}`.padStart(item.max_length, '0')
      select.innerText = item.value
    }
    this.updateDate()
  }

  openDatepicker() {
    this.datepicker.show(); // เปิด Datepicker
  }

  setDate(date: Date) {
    this.date.setFullYear(date.getFullYear(), date.getMonth(), date.getDate())
    this.setItem()
    this.updateDate()
  }
}
