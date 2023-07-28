import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'package:video_call_app/core/constant/data/app_data.dart';



class CallingPageProvider extends ChangeNotifier {
  final String? channelName;
  final ClientRoleType? roleType;
  bool enabledVideo;
  bool muted = false;
  bool viewPanel = false;
  late bool enableVideo;
  final List<int> _users = [];
  final List<String> _infoString = [];

  CallingPageProvider(
      {required this.enabledVideo, this.channelName, this.roleType}) {
    enableVideo = enabledVideo;
    _initialize();
  }

  RtcEngine? _engine;

  List<int> get users => _users;
  List<String> get infoString => _infoString;
  bool get isMuted => muted;
  RtcEngine get engine => _engine!;
  bool get isViewPanelVisible => viewPanel;
  bool get isVideoEnabled => enableVideo;

  Future<void> _initialize() async {
    if (appId.isEmpty) {
      _infoString.add('App ID is missing, please provide your app ID');
      _infoString.add('Agora engine is not starting');
      notifyListeners();
      return;
    }

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    if (enableVideo) {
      await _engine!.enableVideo();
    }
    await _engine!.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine!.setClientRole(role: roleType!);
    _addAgoraEventHandler();
    _engine!.joinChannel(
      token: token,
      channelId: channelName!,
      uid: 0,
      options: ChannelMediaOptions(),
    );
  }

  void _addAgoraEventHandler() {
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onError: (code, text) {
          final info = 'Error: $code';
          _infoString.add(info);
          notifyListeners();
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          final info =
              'Join channel: ${connection.channelId}, UID: ${connection.localUid}';
          _infoString.add(info);
          notifyListeners();
        },
        onLeaveChannel: (RtcConnection connection, stats) {
          _infoString.add('Leave Channel');
          _users.clear();
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, remoteUID, elapsed) {
          final info = 'UserJoined: $remoteUID';
          _infoString.add(info);
          _users.add(remoteUID); // Add the remote user to the list
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, remoteUid, UserOfflineReasonType type) {
          final info = '$remoteUid goes offline because ${type.name}';
          _infoString.add(info);
          _users.remove(remoteUid);
          notifyListeners();
        },
      ),
    );
  }

  void toggleMute() {
    muted = !muted;
    _engine!.muteLocalAudioStream(muted);
    notifyListeners();
  }

  void toggleVideo() {
    if (!enableVideo) {
      Permission.camera.request().then((value) => _engine!.enableVideo());
      enableVideo = true;
    } else {
      _engine!.disableVideo();
      enableVideo = false;
    }
    notifyListeners();
  }

  void toggleViewPanel() {
    viewPanel = !viewPanel;
    notifyListeners();
  }

  @override
  void dispose() {
    _users.clear();
    _engine!.leaveChannel();
    _engine!.release();
    super.dispose();
  }
}