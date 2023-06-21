import 'package:flutter/material.dart';
import 'package:hiring_task/view/screens/home/home_screen.dart';

AppBar HomeAppBarWidget(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    title: const Text('Home'),
    leading: IconButton(
      onPressed: () {
        Navigator.pushNamed(context, HomeScreen.routeName);
      },
      icon: const Icon(
        Icons.home_outlined,
        color: Colors.black,
        size: 30,
      ),
    ),
  );
}
