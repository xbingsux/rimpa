import { Routes } from '@angular/router';
import { AnnouncementBoardComponent } from './announcement-board/announcement-board.component'
import { DashboardComponent } from './dashboard/dashboard.component'
import { EventInfoComponent } from './event-info/event-info.component'
import { EventScanComponent } from './event-scan/event-scan.component'
import { LoginComponent } from './login/login.component'
import { NewsComponent } from './news/news.component'
import { PollComponent } from './poll/poll.component'
import { NotFoundComponent } from './not-found/not-found.component'
import { AuthGuard } from './auth-guard.service'

export const routes: Routes = [
    { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
    { path: 'login', component: LoginComponent },
    { path: 'dashboard', component: DashboardComponent, canActivate: [AuthGuard] },
    { path: 'event', component: EventInfoComponent, canActivate: [AuthGuard] },
    { path: 'news', component: NewsComponent, canActivate: [AuthGuard] },
    { path: 'announcement-board', component: AnnouncementBoardComponent, canActivate: [AuthGuard] },
    { path: 'poll', component: PollComponent, canActivate: [AuthGuard] },
    { path: 'event-scan', component: EventScanComponent, canActivate: [AuthGuard] },
    // {
    //   path: 'dashboard',
    //   component: DashboardComponent,
    //   children: [
    //     { path: 'overview', component: OverviewComponent },
    //     { path: 'analytics', component: AnalyticsComponent },
    //     { path: 'settings', component: SettingsComponent },
    //   ]
    // },
    { path: '**', component: NotFoundComponent },
];
