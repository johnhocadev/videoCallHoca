import 'package:avatar_view/avatar_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_call_app/core/service/localisation/my_words.dart';
import 'package:video_call_app/core/style/colors.dart';
import 'package:video_call_app/core/style/text_style.dart';

class HomeAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  String imageUrl;
   HomeAppBarHome({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) => AppBar(
    elevation: 0,
    leadingWidth: 80.w,
    backgroundColor: Colors.transparent,
    actions: [
      CircleAvatar(
        radius: 18.r,
        backgroundColor: AppColors.cFF949494,
        child: const Icon(Icons.question_mark),
      ),
      SizedBox(width: 15.w),
      Padding(
        padding:  EdgeInsets.symmetric(vertical: 5.h),
        child: MaterialButton(
          onPressed: () => debugPrint("it's pressed"),
          color: AppColors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10).r,
          ),
          child: Text(
            Words.upgrade.tr(),
            style: const AppTextStyle()
                .displayMedium
                ?.copyWith(color: AppColors.white),
          ),
        ),
      ),
      SizedBox(width: 15.w),
    ],
    leading: AvatarView(
      imagePath: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSg-3382ZgdUhzsOz0VYE8KVNtX_HTwTxRSps08Nli1&s',
      placeHolder: Icon(Icons.error),
      avatarType: AvatarType.CIRCLE,
      radius: 20,
      
    ),
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0);
}
