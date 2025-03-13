import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EventScanComponent } from './event-scan.component';

describe('EventScanComponent', () => {
  let component: EventScanComponent;
  let fixture: ComponentFixture<EventScanComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [EventScanComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EventScanComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
