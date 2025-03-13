import { Routes } from '@angular/router';
import { AuthGuard } from './service/auth-guard.service'

import { DashboardComponent } from './admin-page/dashboard/dashboard.component'
import { EventScanComponent } from './admin-page/event-scan/event-scan.component'
import { LoginComponent } from './login/login.component'
import { NotFoundComponent } from './not-found/not-found.component'
import { AdminComponent } from './admin-page/admin/admin.component'
import { EventManagementComponent } from './admin-page/event-management/event-management.component';
import { BannerManagementComponent } from './admin-page/banner-management/banner-management.component';
import { RewardManagementComponent } from './admin-page/reward-management/reward-management.component';
import { UserManagementComponent } from './admin-page/user-management/user-management.component';
import { EventUpdateComponent } from './admin-page/event-update/event-update.component';
import { BannerUpdateComponent } from './admin-page/banner-update/banner-update.component';
import { RewardUpdateComponent } from './admin-page/reward-update/reward-update.component';
import { UserUpdateComponent } from './admin-page/user-update/user-update.component';
import { ForgotPasswordComponent } from './forgot-password/forgot-password.component';
import { NewPasswordComponent } from './new-password/new-password.component';
import { PrivacyPolicyComponent } from './privacy-policy/privacy-policy.component';
import { RewardScanComponent } from './admin-page/reward-scan/reward-scan.component';
import { RewardHistoryComponent } from './admin-page/reward-history/reward-history.component';

export const routes: Routes = [
    { path: '', redirectTo: '/login', pathMatch: 'full' },

    { path: 'privacy-policy', component: PrivacyPolicyComponent },
    { path: 'login', component: LoginComponent, canActivate: [AuthGuard] },
    { path: 'forgot-password', component: ForgotPasswordComponent },
    { path: 'new-password', component: NewPasswordComponent },
    {
        path: 'admin',
        component: AdminComponent,
        canActivate: [AuthGuard],
        children: [
            { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
            { path: 'dashboard', component: DashboardComponent },
            { path: 'event', component: EventManagementComponent },
            { path: 'event-update', component: EventUpdateComponent },
            { path: 'event-update/:id', component: EventUpdateComponent },
            { path: 'banner', component: BannerManagementComponent },
            { path: 'banner-update', component: BannerUpdateComponent },
            { path: 'banner-update/:id', component: BannerUpdateComponent },
            { path: 'reward', component: RewardManagementComponent },
            { path: 'reward-update', component: RewardUpdateComponent },
            { path: 'reward-update/:id', component: RewardUpdateComponent },
            { path: 'reward-scan', component: RewardScanComponent },
            { path: 'reward-history', component: RewardHistoryComponent },
            { path: 'users', component: UserManagementComponent },
            { path: 'user-update', component: UserUpdateComponent },
            { path: 'user-update/:id', component: UserUpdateComponent },
            { path: 'event-scan', component: EventScanComponent },
        ]
    },
    { path: '**', component: NotFoundComponent },
];
