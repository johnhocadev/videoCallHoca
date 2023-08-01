import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/presentation/page/create_channel_page.dart';
import 'package:video_call_app/pages/home/presentation/page/home_page.dart';
import 'package:video_call_app/pages/main/presentation/widget/main_bottom_bar.dart';
import 'package:video_call_app/pages/main/presentation/widget/main_floating_button.dart';
import 'package:video_call_app/pages/main/view_model/provider/main_prov.dart';
import 'package:video_call_app/pages/settings/presentation/pages/settings_page.dart';

class MainPage extends ConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainTool = ref.watch(mainProvider);
    const _pages = <Widget>[
      HomePage(),
      CreateChannelPage(),
      SettingsPage(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: _pages[mainTool.pageIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: MainBottomBar(index: mainTool.pageIndex, changePageIndex: mainTool.changePageIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: MainFloatingButton(index: mainTool.pageIndex, changePageIndex: mainTool.changePageIndex),
    );
  }
}



