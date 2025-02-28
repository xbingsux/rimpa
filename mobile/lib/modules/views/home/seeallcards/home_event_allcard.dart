import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

import '../../../../components/cards/app-card.component.dart';
import '../../../../components/dropdown/app-dropdown.component.dart';
import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';
import '../../../models/listevent.model.dart';
import '../../../controllers/listevent/listevent.controller.dart';
import '../homedetail/home_detail.dart';

class HomeEventAllcard extends StatefulWidget {
  @override
  _HomeEventAllcardState createState() => _HomeEventAllcardState();
}

class _HomeEventAllcardState extends State<HomeEventAllcard> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;
  final listEventController = Get.put(ListEventController());
  String _sortOrder = "ใหม่สุด";

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
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.grey),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
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
      body: Obx(() {
        if (listEventController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<ListEvent> sortedEvents = listEventController.events.toList();
          if (_sortOrder == "ใหม่สุด") {
            sortedEvents.sort((a, b) => b.id.compareTo(a.id));
          } else {
            sortedEvents.sort((a, b) => a.id.compareTo(b.id));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grid Section
                  AppDropdown(
                    onChanged: (value) {
                      setState(() {
                        _sortOrder = value;
                      });
                    },
                    choices: ["ใหม่สุด", "เก่าสุด"],
                    active: _sortOrder,
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
                    itemCount: sortedEvents.length,
                    itemBuilder: (context, index) {
                      var event = sortedEvents[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => HomeDetailPage(event: event));
                        },
                        child: AppCardComponent(
                          child: Column(
                            children: [
                              AppImageComponent(
                                imageType: AppImageType.network,
                                imageAddress:
                                    '${AppApi.urlApi}${event.subEvents[0].imagePath}',
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  event.title,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
