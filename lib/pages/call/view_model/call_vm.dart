import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call_app/pages/call/presentation/page/call_page.dart';

class CallVM extends ChangeNotifier {



  late RtcEngine engine;
  bool localUserJoined = false;
  bool switcher = false;

  Future<void> initAgora([int? _remoteUid]) async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");

            localUserJoined = !localUserJoined;
             notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");

            _remoteUid = remoteUid;
          notifyListeners();

        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
            _remoteUid = null;
          notifyListeners();

        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: token,
      channelId: 'videocall',
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  // remote user video
  Widget remoteVideo([int? _remoteUid]) {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: 'videocall'),
        ),
      );
    } else {
      return Text(
        'Please wait remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
