import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/view_model/provider/call_provider.dart';

class SwitcherWidget extends StatefulHookConsumerWidget {
  final bool switcher;
  const SwitcherWidget({required this.switcher,Key? key}) : super(key: key);

  @override
  ConsumerState<SwitcherWidget> createState() => _SwitcherWidgetState();
}

class _SwitcherWidgetState extends ConsumerState<SwitcherWidget> with SingleTickerProviderStateMixin {
  bool isChecked = false;
  Duration _duration = Duration(milliseconds: 370);
  late Animation<Alignment> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _duration);
    _animation =
        AlignmentTween(begin: Alignment.centerLeft, end: Alignment.centerRight)
            .animate(
          CurvedAnimation(
              parent: _animationController,
              curve: Curves.bounceOut,
              reverseCurve: Curves.bounceIn),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final callTool = ref.watch(callProvider);
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Center(
          child: Container(
            width: 100,
            height: 40,
            padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
            decoration: BoxDecoration(
                color: callTool.switcher ? Colors.black : Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                      color: callTool.switcher ? Colors.black : Colors.grey,
                      blurRadius: 12,
                      offset: Offset(0, 8))
                ]),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: _animation.value,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_animationController.isCompleted) {
                          _animationController.reverse();
                        } else {
                          _animationController.forward();
                        }
                        callTool.switcher = !callTool.switcher;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
