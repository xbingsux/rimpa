import 'package:flutter/material.dart';
import 'dart:async';

import '../../../components/cards/app-card.component.dart';
import '../../../components/dropdown/app-dropdown.component.dart';
import '../../../components/imageloader/app-image.component.dart';

class HomeEventPage extends StatefulWidget {
  @override
  _HomeEventPageState createState() => _HomeEventPageState();
}

class _HomeEventPageState extends State<HomeEventPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 7) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor, // รองรับ Light/Dark Mode
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "กิจกรรม",
                style: TextStyle(color: Color(0xFF1E54FD), fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.notifications_none, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grid Section
              AppDropdown(
                onChanged: (value) {
                  // Handle sorting action
                },
                choices: ["ใหม่สุด", "เก่าสุด"],
                active: "เรียงตาม",
              ),
              SizedBox(height: 8),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: 8,
                itemBuilder: (context, index) => AppCardComponent(
                  child: Column(
                    children: [
                      AppImageComponent(
                        imageType: AppImageType.network,
                        imageAddress:
                            "https://scontent.fbkk22-3.fna.fbcdn.net/v/t39.30808-6/470805346_1138761717820563_3034092518607465864_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGAqyEMQM1w0WCxcU9HbQtVgomPYyEmDp6CiY9jISYOnhLKioAFlnwgv1uyEqsea1kTwsVCn5v_2GsQLAcVdDih&_nc_ohc=ocDVfwsdMo8Q7kNvgHWpTur&_nc_oc=AdjXgAYJHgW9mkpDXsFIQKvGPQFjBbzmLvgHQrse3P48yVfuYm3zACZRaJf8mBy33vI&_nc_zt=23&_nc_ht=scontent.fbkk22-3.fna&_nc_gid=A5zg6PLt8m9qXH766j0c-p1&oh=00_AYCzPq2KQuMwMji2QNMvbAFLm_P9q_-bs-uU3hRZPex_vg&oe=67AB8A79",
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing",
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
