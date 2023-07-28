import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/view_model/calling_vm.dart';

class ToolBar extends ConsumerWidget {
  const ToolBar({
    super.key,
    required this.provider,
  });

  final CallingPageProvider provider;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    // if (roleType == ClientRoleType.clientRoleAudience) return SizedBox();
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: provider.isMuted ? Colors.blueAccent : Colors.white,
            padding: EdgeInsets.all(12.0),
            child: Icon(
              provider.isMuted ? Icons.mic_off : Icons.mic,
              color: provider.isMuted ? Colors.white : Colors.blue,
            ),
            onPressed: () {
              provider.toggleMute();
            },
          ),
          RawMaterialButton(
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: EdgeInsets.all(15.0),
            onPressed: () => Navigator.pop(context),
          ),
          RawMaterialButton(
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: EdgeInsets.all(15.0),
            child: Icon(
              provider.isVideoEnabled ? Icons.camera_alt : Icons.camera,
              color: provider.isVideoEnabled ? Colors.black : Colors.blue,
              size: 35,
            ),
            onPressed: () async{
              await provider.toggleVideo();
            },
          ),
        ],
      ),
    );
  }
}
