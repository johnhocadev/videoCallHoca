
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_call_app/pages/call/utils/agora_user.dart';

import 'agora_video_view.dart';

class AgoraVideoLayout extends StatelessWidget {
  const AgoraVideoLayout({
    super.key,
    required List<AgoraUser> users,
    required List<int> views,
    required double viewAspectRatio,
  })  : _users = users,
        _views = views,
        _viewAspectRatio = viewAspectRatio;

  final List<AgoraUser> _users;
  final List<int> _views;
  final double _viewAspectRatio;

  @override
  Widget build(BuildContext context) {
    int totalCount = _views.reduce((value, element) => value + element);
    int rows = _views.length;
    int columns = _views.reduce(max);

    List<Widget> rowsList = [];
    for (int i = 0; i < rows; i++) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < columns; j++) {
        int index = i * columns + j;
        if (index < totalCount) {
          rowChildren.add(
            AgoraVideoView(
              user: _users.elementAt(index),
              viewAspectRatio: _viewAspectRatio,
            ),
          );
        } else {
          rowChildren.add(
            const SizedBox.shrink(),
          );
        }
      }
      rowsList.add(
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren,
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowsList,
    );
  }
}
