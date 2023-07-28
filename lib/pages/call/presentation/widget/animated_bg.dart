import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/view_model/provider/call_provider.dart';

class AnimatingBg extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callTool = ref.watch(callProvider);
    final bottomColor = callTool.bottomColor;
    final topColor = callTool.topColor;

    return AnimatedContainer(
      duration: Duration(seconds: 2),
      onEnd: () {
        callTool.updateColors();
      },
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: callTool.begin,
          end: callTool.end,
          colors: [bottomColor, topColor],
        ),
      ),
    );
  }
}
