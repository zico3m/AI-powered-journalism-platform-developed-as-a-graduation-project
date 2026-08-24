import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../view/ArticleView/ArticlesView.dart';
import '../../view/Chat/news_chat_screen.dart';
import '../../view/settings/SettingsScreen.dart';
import '../../view/home/Home_main_view.dart';
import '../../view/interest/my_interests_page.dart';
class RootController extends GetxController {


  final RxInt currentIndex = 0.obs;


  final List<Widget> pages = [
     HomeMainView(),
    InterestStreamView(),
    ArticlesView(),
    NewsChatScreen(),
    SettingsView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
