import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AnnouncementBoardComponent } from './announcement-board.component';

describe('AnnouncementBoardComponent', () => {
  let component: AnnouncementBoardComponent;
  let fixture: ComponentFixture<AnnouncementBoardComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AnnouncementBoardComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AnnouncementBoardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
