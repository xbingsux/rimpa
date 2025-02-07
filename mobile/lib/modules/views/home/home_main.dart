import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rimpa/components/dropdown/app-dropdown.component.dart';

import '../../../components/cards/app-card.component.dart';
import '../../../components/imageloader/app-image.component.dart'; // Import AppDropdown

class HomeMainPage extends StatefulWidget {
  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.person_outline,
                      color: Colors.grey), // Change color to gray
                ),
                SizedBox(width: 8),
                Text(
                  "Username",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            Icon(Icons.notifications_none, color: Colors.grey),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner slider
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 8,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: AppImageComponent(
                      imageType: AppImageType.network,
                      imageAddress:
                          "https://scontent.fbkk22-3.fna.fbcdn.net/v/t39.30808-6/470805346_1138761717820563_3034092518607465864_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGAqyEMQM1w0WCxcU9HbQtVgomPYyEmDp6CiY9jISYOnhLKioAFlnwgv1uyEqsea1kTwsVCn5v_2GsQLAcVdDih&_nc_ohc=ocDVfwsdMo8Q7kNvgHWpTur&_nc_oc=AdjXgAYJHgW9mkpDXsFIQKvGPQFjBbzmLvgHQrse3P48yVfuYm3zACZRaJf8mBy33vI&_nc_zt=23&_nc_ht=scontent.fbkk22-3.fna&_nc_gid=A5zg6PLt8m9qXH766j0c-p1&oh=00_AYCzPq2KQuMwMji2QNMvbAFLm_P9q_-bs-uU3hRZPex_vg&oe=67AB8A79",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(8, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),
              // Activities Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "กิจกรรมแนะนำ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        "ดูทั้งหมด",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        " >",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(8, (index) {
                    return Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 8),
                      child: AppCardComponent(
                        child: Column(
                          children: [
                            AppImageComponent(
                              imageType: AppImageType.network,
                              imageAddress:
                                  "https://scontent.fbkk22-3.fna.fbcdn.net/v/t39.30808-6/470805346_1138761717820563_3034092518607465864_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGAqyEMQM1w0WCxcU9HbQtVgomPYyEmDp6CiY9jISYOnhLKioAFlnwgv1uyEqsea1kTwsVCn5v_2GsQLAcVdDih&_nc_ohc=ocDVfwsdMo8Q7kNvgHWpTur&_nc_oc=AdjXgAYJHgW9mkpDXsFIQKvGPQFjBbzmLvgHQrse3P48yVfuYm3zACZRaJf8mBy33vI&_nc_zt=23&_nc_ht=scontent.fbkk22-3.fna&_nc_gid=A5zg6PLt8m9qXH766j0c-p1&oh=00_AYCzPq2KQuMwMji2QNMvbAFLm_P9q_-bs-uU3hRZPex_vg&oe=67AB8A79",
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                "Lorem Ipsum is simply dummy text of the printing",
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              // Add dashed line
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: List.generate(60, (index) {
                    return Expanded(
                      child: Container(
                        color:
                            index % 2 == 0 ? Colors.transparent : Colors.grey,
                        height: 1,
                      ),
                    );
                  }),
                ),
              ),
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
