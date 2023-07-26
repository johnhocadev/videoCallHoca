import 'package:flutter/material.dart';
import 'package:video_call_app/pages/home/presentation/widget/home_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: HomeAppBarHome(),
    );
  }
}
