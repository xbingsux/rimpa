import { HttpClient, HttpParams } from '@angular/common/http';
import { Component, Input, OnInit, ViewChild, viewChild } from '@angular/core';
import { environment } from '../../../environments/environment';
import { DatePipe, NgClass, NgFor, NgIf } from '@angular/common';
import { ApiService } from '../../api/api.service';
import { FormsModule } from '@angular/forms';
import { ZXingScannerComponent, ZXingScannerModule } from '@zxing/ngx-scanner';
import { Result } from '@zxing/library';

@Component({
  selector: 'app-reward-scan',
  standalone: true,
  imports: [NgFor, DatePipe, NgIf, FormsModule, NgClass, ZXingScannerModule],
  templateUrl: './reward-scan.component.html',
  styleUrl: './reward-scan.component.scss'
})
export class RewardScanComponent implements OnInit {

  constructor(private http: HttpClient, public api: ApiService) { }
  tz = environment.timeZone;
  list: any[] = []

  ngOnInit(): void {
    this.http.get(`${environment.API_URL}/reward-history`, {}).subscribe(async (response: any) => {
      // console.log(response.history);
      this.list = response.history

      this.list.map(async (item: any) => {
        if (item.Reward.img) {
          let url = `${environment.API_URL}${item.Reward.img.replace('src', '')}`
          const status = await this.api.checkImageExists(url)
          if (status === 500 || status === 404) {
            item.Reward.img = null;
          }
        }
        return item;
      })
    }, error => {
      console.error('Error:', error);
    });

  }

  getImg(url: string) {
    let path = `${environment.API_URL}${url.replace('src', '')}`
    return path
  }

  noData = false;
  scanning = false
  barcode_focus = false
  data_scan: RewardOrder | null = null;

  onBarcodeScanned(event: Event) {
    const inputElement = event.target as HTMLInputElement;
    const scannedData = inputElement.value.trim();

    if (scannedData) {
      console.log("Scanned barcode:", scannedData);
      this.processScannedData(scannedData, inputElement);
      inputElement.value = ''; // ล้างค่า input หลังจากอ่านค่าเสร็จ
    }
  }

  processScannedData(token: string, event: HTMLInputElement) {
    // ดำเนินการกับข้อมูลที่ได้รับ เช่น เรียก API หรือเพิ่มลงในรายการสินค้า
    console.log("Processing scanned data:", token);
    if (token.trim() != '') {
      this.http.post(`${environment.API_URL}/redeem-rewards`, { token: token }).subscribe((response: any) => {
        console.log(response.redeem);
        if (response.redeem) {
          let data = response.redeem;
          const remainingPoints = +data.Profile.points;
          this.data_scan = new RewardOrder({ profile_name: data.Profile.profile_name, reward_name: data.Reward.reward_name, totalPoints: +data.usedCoints + remainingPoints, usedPoints: data.usedCoints, date: new Date(data.createdAt) })
        }
        this.api.addAlert('success', 'ชำระเงินสำเร็จ');
        this.ngOnInit()
      }, error => {
        event.blur()
        console.error('Error:', error);
        alert('สแกนไม่สำเร็จ')
      });
    }
  }

  barcode = ''
  getRedeem() {
    if (this.barcode.length == 10) {
      this.noData = true;
      const params = new HttpParams().set('barcode', Number(this.barcode));
      this.http.get(`${environment.API_URL}/get-redeem`, { params }).subscribe(async (response: any) => {
        console.log(response.redeem);
        if (response.redeem?.status == 'PENDING') {
          let redeem = response.redeem;
          this.data_scan = new RewardOrder({ profile_name: redeem.Profile.profile_name, reward_name: redeem.Reward.reward_name, totalPoints: redeem.Profile.points, usedPoints: redeem.usedCoints, date: new Date(redeem.createdAt) })
          this.noData = false;
          this.barcode_focus = false;
        } else {
          this.barcode_focus = false
        }

      }, error => {
        console.error('Error:', error);
      });
    } else {
      this.data_scan = null
      this.barcode_focus = true;
      this.noData = false;
    }
  }

  submitRedeem() {
    this.http.post(`${environment.API_URL}/redeem-rewards`, { barcode: this.barcode }).subscribe((response: any) => {
      console.log(response.redeem);
      if (response.redeem) {
        // let data = response.redeem;
        // this.data_scan = new RewardOrder({ profile_name: data.Profile.profile_name, reward_name: data.Reward.reward_name, totalPoints: data.Profile.points, usedPoints: data.usedCoints, date: new Date(data.createdAt) })
        this.barcode = ''
        this.api.addAlert('success', 'ชำระเงินสำเร็จ');
        this.ngOnInit()
      }
    }, error => {
      console.error('Error:', error);
      alert('ชำระเงินไม่สำเร็จ')
    });
  }

  //
  init = true;
  ngAfterContentChecked() {
    if (this.init) {
      this.init = false;
    }
  }

  ngAfterViewInit(): void {
    this.scanner.camerasFound.subscribe((devices: MediaDeviceInfo[]) => {
      console.log('✅ กล้องที่พบ:', devices);

      this.hasDevices = true;
      this.availableDevices = devices;

      const backCam = devices.find(device =>
        /back|rear|environment/gi.test(device.label)
      );

      this.currentDevice = backCam ?? devices[0];
    });

    this.scanner.camerasNotFound.subscribe(() => {
      this.hasDevices = false;
      console.warn('❌ ไม่พบกล้อง');
    });

    this.scanner.scanComplete.subscribe((result: Result) => {
      this.qrResult = result;
      console.log('📦 Scan result:', result.getText());
    });

    this.scanner.permissionResponse.subscribe((perm: boolean) => {
      this.hasPermission = perm;
      console.log('🔐 Permission:', perm);
    });
  }


  @ViewChild('scanner')
  scanner!: ZXingScannerComponent;

  hasPermission!: boolean;
  hasDevices!: boolean;
  qrResultString!: string;
  qrResult!: Result;

  availableDevices!: MediaDeviceInfo[];
  currentDevice!: MediaDeviceInfo;

  displayCameras(cameras: MediaDeviceInfo[]) {
    console.debug('Devics: ', cameras);
    this.availableDevices = cameras;
  }

  handleQrCodeResult(resultString: string) {
    console.debug('Result: ', resultString);
    this.qrResultString = resultString;
  }

  // onDeviceSelectChange(selectdValue: string) {
  //   console.debug('Selection changed: ', selectdValue);
  //   // this.scanner.camerasFound.subscribe()
  //   // this.currentDevice = this.scanner.device.find(d => d.deviceId === selectedValue);

  // }

  onDeviceSelectChange(event: Event) {
    this.scanner.restart()

    const target = event.target as HTMLSelectElement | null;

    if (target?.value) {
      const selectedDeviceId = target.value;
      const device = this.availableDevices.find(d => d.deviceId === selectedDeviceId);
      if (device) {
        this.currentDevice = device;
      }
    }
  }

  onScanError(error: any) {
    console.error('❌ Scan error:', error);

    alert('เปิดกล้องไม่สำเร็จ กรุณา:\n- ปิดแอปอื่นที่ใช้กล้อง\n- ตรวจสอบว่าให้สิทธิ์เบราว์เซอร์ใช้กล้องแล้ว\n- เปลี่ยนกล้องตัวอื่น');
  }

  onCamerasFound(devices: MediaDeviceInfo[]) {
    this.hasDevices = true;
    this.availableDevices = devices;

    const backCam = devices.find(device =>
      /back|rear|environment/gi.test(device.label)
    );

    this.currentDevice = backCam ?? devices[0];
  }


  openScan() {

  }

}

class RewardOrder {
  profile_name: string
  date: Date
  reward_name: string
  totalPoints: number;  // คะแนนทั้งหมดที่มี
  usedPoints: number;    // คะแนนที่ใช้ไป
  remainingPoints = () => {
    return this.totalPoints - this.usedPoints
  } // คะแนนคงเหลือ
  constructor({ profile_name = '', reward_name = '', totalPoints = 0, usedPoints = 0, date = new Date() }: Partial<RewardOrder> = {}) {
    this.profile_name = profile_name;
    this.reward_name = reward_name;
    this.totalPoints = totalPoints;
    this.usedPoints = usedPoints;
    this.date = date
  }
}