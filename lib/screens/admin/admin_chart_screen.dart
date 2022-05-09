import "package:flutter/material.dart";

class AdminChartScreen extends StatefulWidget {
  const AdminChartScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-chart';

  @override
  State<AdminChartScreen> createState() => _AdminChartScreenState();
}

class _AdminChartScreenState extends State<AdminChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
