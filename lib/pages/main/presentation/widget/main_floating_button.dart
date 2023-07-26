import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_call_app/core/constant/typedefs/typedef.dart';
import 'package:video_call_app/core/style/colors.dart';

class MainFloatingButton extends StatelessWidget {
  const MainFloatingButton({
    required this.index,
    required this.changePageIndex,
    super.key,
  });

  final ChangePageIndex changePageIndex;
  final int index;

  @override
  Widget build(BuildContext context) => Container(
      height: 90.h,
      width: 70.w,
      padding: const EdgeInsets.all(5),
      child: FloatingActionButton(
        backgroundColor:
        index == 1 ? AppColors.black : AppColors.green,
        child: Icon(
          Icons.phone,
          size: 30.sp,
        ),
        onPressed: () => changePageIndex(1),
      ),
    );
}