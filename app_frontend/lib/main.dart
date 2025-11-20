import 'package:flutter/material.dart';
import 'ui/dashboard.dart';

void main() => runApp(const ShadowLearn());

class ShadowLearn extends StatelessWidget {
  const ShadowLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ShadowLearn",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Inter",
      ),
      home: Dashboard(),
    );
  }
}
