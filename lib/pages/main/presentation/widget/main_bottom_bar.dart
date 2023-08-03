import 'package:flutter/material.dart';
import 'package:video_call_app/core/constant/typedefs/typedef.dart';
import 'package:video_call_app/core/style/colors.dart';

class MainBottomBar extends StatelessWidget {
  const MainBottomBar({
    required this.index,
    required this.changePageIndex,
    super.key,
  });

  final ChangePageIndex changePageIndex;
  final int index;

  @override
  Widget build(BuildContext context) => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 2,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(
                top: BorderSide(
                  color: AppColors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: index,
              backgroundColor: AppColors.white,
              unselectedItemColor: AppColors.grey,
              selectedItemColor: AppColors.deepPurple,
              onTap: changePageIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.call), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: ''),
              ],
            ),
          ),
        ),
      );
}
