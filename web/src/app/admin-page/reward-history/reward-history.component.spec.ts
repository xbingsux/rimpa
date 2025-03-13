import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RewardHistoryComponent } from './reward-history.component';

describe('RewardHistoryComponent', () => {
  let component: RewardHistoryComponent;
  let fixture: ComponentFixture<RewardHistoryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RewardHistoryComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RewardHistoryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
