import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BannerUpdateComponent } from './banner-update.component';

describe('BannerUpdateComponent', () => {
  let component: BannerUpdateComponent;
  let fixture: ComponentFixture<BannerUpdateComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BannerUpdateComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(BannerUpdateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
