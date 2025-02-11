import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/theme/theme_controller.dart';
import '../../../widgets/loginWidget/custom_loginpage.dart';
import '../../controllers/auth.controller.dart';
import '../../../core/constant/app.constant.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

bool _rememberPassword = false; // ตัวแปรจำรหัส

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final authController = Get.put(LoginController());
  late TabController _tabController; // ตัวควบคุมสำหรับ Tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // เพิ่ม listener เพื่อรีเฟรชเมื่อมีการเปลี่ยนแปลงแท็บ
    _tabController.addListener(() {
      if (mounted) {
        setState(() {
          // การรีเฟรชหรือเปลี่ยนแปลงบางสิ่งที่ต้องการ
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // อย่าลืม dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ส่วนของ Banner ด้านบน
          AspectRatio(
            aspectRatio: 4 / 3, // ตั้งอัตราส่วน 16:9
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logoapp/logoiconic.png'),
                  fit: BoxFit.contain, // ป้องกันภาพเสียรูป
                ),
              ),
            ),
          ),

          // BottomSheet ที่ครึ่งล่างของจอ
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height *
                  0.7, // 70% ของความสูงของหน้าจอ
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color.fromARGB(255, 26, 25,
                        25) // สีพื้นหลังของ BottomSheet ในโหมดดาร์ค
                    : Colors.white, // สีพื้นหลังของ BottomSheet ในโหมดไลท์
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // TabBar ที่ด้านบนของ BottomSheet
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              if (_tabController.index == 0) {
                                return LinearGradient(
                                  colors: [
                                    Color(0xFF1E54FD),
                                    Color(0xFF0ACCF5),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(
                                    bounds); // ใช้ Linear Gradient กับข้อความเมื่อเลือก
                              } else {
                                return const LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                  ], // ไม่มี Gradient เมื่อไม่ได้เลือก
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds);
                              }
                            },
                            child: Text(
                              'อีเมล',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: _tabController.index == 0
                                    ? Colors.white // ตัวอักษรสีขาวเมื่อเลือก
                                    : Color.fromARGB(255, 158, 158,
                                        158), // ตัวอักษรสีแดงเมื่อไม่ได้เลือก
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              if (_tabController.index == 1) {
                                return LinearGradient(
                                  colors: [
                                    Color(0xFF1E54FD),
                                    Color(0xFF0ACCF5),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(
                                    bounds); // ใช้ Linear Gradient กับข้อความเมื่อเลือก
                              } else {
                                return const LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                  ], // ไม่มี Gradient เมื่อไม่ได้เลือก
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds);
                              }
                            },
                            child: Text(
                              'เบอร์โทรศัพท์',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: _tabController.index == 1
                                    ? Colors.white // ตัวอักษรสีขาวเมื่อเลือก
                                    : Color.fromARGB(255, 158, 158,
                                        158), // ตัวอักษรสีแดงเมื่อไม่ได้เลือก
                              ),
                            ),
                          ),
                        ),
                      ],
                      indicator: GradientTabIndicator(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1E54FD), Color(0xFF0ACCF5)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    // ฟอร์มที่จะแสดงตามแท็บที่เลือก
                    Flexible(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // ฟอร์มสำหรับ "อีเมล"
                          Column(
                            children: [
                              CustomTextField(
                                labelText: 'อีเมล',
                                obscureText: false,
                                onChanged: (value) =>
                                    authController.user.email.value = value,
                              ),
                              SizedBox(height: AppSpacing.md),
                              CustomTextField(
                                labelText: 'รหัสผ่าน',
                                obscureText: true,
                                onChanged: (value) =>
                                    authController.user.password.value = value,
                              ),
                              SizedBox(height: AppSpacing.md),
                              // ลืมรหัสและจำรหัส
                              RememberPasswordWidget(
                                rememberPassword: _rememberPassword,
                                onRememberChanged: (value) {
                                  setState(() {
                                    _rememberPassword = value;
                                  });
                                },
                               onForgotPassword: () {
                                  Get.toNamed('/forgot-password');
                                },
                              ),
                              SizedBox(height: AppSpacing.md),
                              CustomButton(
                                text: 'เข้าสู่ระบบ',
                                onPressed: () =>
                                    authController.loginwithemail(),
                              ),
                              SizedBox(height: AppSpacing.md),
                              Ordesign(
                                text: 'หรือ',
                              ),
                              SizedBox(
                                  height: AppSpacing
                                      .md), // ระยะห่างระหว่าง "หรือ" กับปุ่ม social login
                              SocialLoginButtons(
                                onGooglePressed: () {
                                  print("เข้าสู่ระบบด้วย Google");
                                },
                                onApplePressed: () {
                                  print("เข้าสู่ระบบด้วย Apple");
                                },
                                onFacebookPressed: () {
                                  print("เข้าสู่ระบบด้วย Facebook");
                                },
                              ),
                              SizedBox(height: AppSpacing.md),
                              // ปุ่ม Create Account
                              CreateAccountButton(
                                onPressed: () => Get.toNamed('/select-create'),
                              ),
                            ],
                          ),
                          // ฟอร์มสำหรับ "โทรศัพท์"
                          Column(
                            children: [
                              CustomPhoneTextField(
                               
                              ),

                              SizedBox(height: AppSpacing.md),
                              CustomTextField(
                                labelText: 'รหัสผ่าน',
                                obscureText: true,
                                onChanged: (value) =>
                                    authController.user.password.value = value,
                              ),
                              SizedBox(height: AppSpacing.md),
                              // ลืมรหัสและจำรหัส
                              RememberPasswordWidget(
                                rememberPassword: _rememberPassword,
                                onRememberChanged: (value) {
                                  setState(() {
                                    _rememberPassword = value;
                                  });
                                },
                                onForgotPassword: () {
                                  Get.toNamed('/forgot-password');
                                },
                              ),
                              SizedBox(height: AppSpacing.md),
                              CustomButton(
                                text: 'เข้าสู่ระบบ',
                                onPressed: () =>
                                    authController.loginwithemail(),
                              ),
                              SizedBox(height: AppSpacing.md),
                              Ordesign(
                                text: 'หรือ',
                              ),
                              SizedBox(
                                  height: AppSpacing
                                      .md), // ระยะห่างระหว่าง "หรือ" กับปุ่ม social login
                              SocialLoginButtons(
                                onGooglePressed: () {
                                  print("เข้าสู่ระบบด้วย Google");
                                },
                                onApplePressed: () {
                                  print("เข้าสู่ระบบด้วย Apple");
                                },
                                onFacebookPressed: () {
                                  print("เข้าสู่ระบบด้วย Facebook");
                                },
                              ),
                              SizedBox(height: AppSpacing.md),
                              // ปุ่ม Create Account
                              CreateAccountButton(
                                onPressed: () => Get.toNamed('/select-create'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ปุ่มเปลี่ยนธีมที่มุมขวาบน
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                Get.find<ThemeController>().toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// สีเส้นtabbar
class GradientTabIndicator extends Decoration {
  final Gradient gradient;

  const GradientTabIndicator({required this.gradient});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GradientPainter(gradient);
  }
}

class _GradientPainter extends BoxPainter {
  final Gradient gradient;

  _GradientPainter(this.gradient);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if (configuration.size == null) return;

    // เช็คว่าถ้าไม่ได้ถูกเลือกให้ไม่วาดเส้น
    if (configuration.size!.height == 0) return;

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(offset.dx, configuration.size!.height - 1.0,
            configuration.size!.width, 1.0),
      )
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(offset.dx, configuration.size!.height - 1.5,
          configuration.size!.width, 1.5),
      paint,
    );
  }
}
