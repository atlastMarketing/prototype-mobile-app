import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'configs/theme.dart';
import 'data/main_navigation.dart';
import 'data/scheduled_posts.dart';
import 'data/user.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScheduledPostsStore()),
        ChangeNotifierProvider(create: (context) => MainNavigationStore()),
        ChangeNotifierProvider(create: (context) => UserStore()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlast Marketing App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: AppColors.primary,
        fontFamily: 'Quicksand',
      ),
      home: const App(),
    );
  }
}
