import 'package:flutter/material.dart';
import 'package:image_search_example/screens/search/search_page.dart';

import 'constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.orange,
      ),
      home: const SearchPage(),
    );
  }
}