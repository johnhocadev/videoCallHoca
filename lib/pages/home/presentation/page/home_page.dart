import 'package:flutter/material.dart';
import 'package:video_call_app/pages/home/presentation/widget/home_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: HomeAppBarHome(imageUrl: 'https://images.unsplash.com/photo-1690086142286-caccce218c0e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=930&q=80',),
    );
  }
}
