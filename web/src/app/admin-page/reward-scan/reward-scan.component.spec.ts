import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RewardScanComponent } from './reward-scan.component';

describe('RewardScanComponent', () => {
  let component: RewardScanComponent;
  let fixture: ComponentFixture<RewardScanComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RewardScanComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RewardScanComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
