import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RewardUpdateComponent } from './reward-update.component';

describe('RewardUpdateComponent', () => {
  let component: RewardUpdateComponent;
  let fixture: ComponentFixture<RewardUpdateComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RewardUpdateComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RewardUpdateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
