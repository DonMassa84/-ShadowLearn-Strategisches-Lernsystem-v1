import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ShadowLearn Dashboard")),
      body: const Center(
        child: Text("ShadowLearn – Lernsystem aktiv", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
