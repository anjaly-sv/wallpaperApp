import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperapp/screens/ProviderrCls/providerr.dart';
import 'package:wallpaperapp/screens/homepage.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ImageNotifier(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
