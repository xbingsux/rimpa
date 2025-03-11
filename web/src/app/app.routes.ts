import { Routes } from '@angular/router';
import { AuthGuard } from './service/auth-guard.service'

import { DashboardComponent } from './dashboard/dashboard.component'
import { EventScanComponent } from './event-scan/event-scan.component'
import { LoginComponent } from './login/login.component'
import { NotFoundComponent } from './not-found/not-found.component'
import { AdminComponent } from './admin/admin.component'
import { EventManagementComponent } from './event-management/event-management.component';
import { BannerManagementComponent } from './banner-management/banner-management.component';
import { RewardManagementComponent } from './reward-management/reward-management.component';
import { UserManagementComponent } from './user-management/user-management.component';
import { EventUpdateComponent } from './event-update/event-update.component';
import { BannerUpdateComponent } from './banner-update/banner-update.component';
import { RewardUpdateComponent } from './reward-update/reward-update.component';
import { UserUpdateComponent } from './user-update/user-update.component';
import { ForgotPasswordComponent } from './forgot-password/forgot-password.component';
import { NewPasswordComponent } from './new-password/new-password.component';
import { PrivacyPolicyComponent } from './privacy-policy/privacy-policy.component';

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
            { path: 'users', component: UserManagementComponent },
            { path: 'user-update', component: UserUpdateComponent },
            { path: 'user-update/:id', component: UserUpdateComponent },
            { path: 'event-scan', component: EventScanComponent },
        ]
    },
    { path: '**', component: NotFoundComponent },
];
