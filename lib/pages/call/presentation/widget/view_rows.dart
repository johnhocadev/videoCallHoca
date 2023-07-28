import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:video_call_app/pages/call/view_model/calling_vm.dart';

import 'animated_bg.dart';

class ViewRows extends StatelessWidget {
  const ViewRows({
    super.key,
    required this.roleType,
    required this.channelName,
    required this.provider,
  });

  final ClientRoleType? roleType;
  final String? channelName;
  final CallingPageProvider provider;

  @override
  Widget build(BuildContext context) {
    final List<StatefulWidget> list = [];

    // Add the broadcaster's video view
    if (roleType == ClientRoleType.clientRoleBroadcaster) {
      list.add(AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: provider.engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      ));
    }

    // Add video views for all the users
    for (var uid in provider.users) {
      list.add(AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: provider.engine,
          canvas: VideoCanvas(uid: uid),
          connection: RtcConnection(channelId: '$channelName'),
        ),
      ));
    }

    final views = list;
         if(views.length == 1){
           return Stack(
             children: [
               AnimatingBg(),
               Align(
                 alignment: Alignment.center,
                 child: Text("Connecting..."),
               )


             ],
           );
         }
    return Column(
      children: List.generate(
        views.length,
            (index) => Expanded(
          child: views[index],
        ),
      ),
    );
  }
}







