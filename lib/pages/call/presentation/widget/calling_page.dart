import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/view_model/call_vm.dart';

class CallingPage extends ConsumerWidget {
 final CallVM callTool;
 final int remoteUid;
  const CallingPage({
    required this.callTool,
    required this.remoteUid,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context,WidgetRef ref) {



    callTool.initAgora(remoteUid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: callTool.remoteVideo(remoteUid),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: callTool.localUserJoined
                    ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: callTool.engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );


  }






}
