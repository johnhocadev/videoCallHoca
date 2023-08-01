import 'dart:io';
import 'dart:math';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_call_app/pages/call/utils/agora_user.dart';

class VideoCallStateNotifier extends ChangeNotifier {
  late RtcEngine _agoraEngine;
  final List<AgoraUser> _users = <AgoraUser>[];
  double viewAspectRatio = 2 / 3;

  int? _currentUid;
  bool _isMicEnabled = false;
  bool _isVideoEnabled = false;

  List<AgoraUser> get users => _users;

  bool get isMicEnabled => _isMicEnabled;

  bool get isVideoEnabled => _isVideoEnabled;

  @override
 void dispose()async {
    await _agoraEngine.destroy();
    super.dispose();
  }

  Future<void> initialize(
    String appId,
    String token,
    String channelName,
    bool isMicEnabled,
    bool isVideoEnabled,
  ) async {
    // Set aspect ratio for video according to platform
    if (kIsWeb) {
      viewAspectRatio = 3 / 2;
    } else if (Platform.isAndroid || Platform.isIOS) {
      viewAspectRatio = 2 / 3;
    } else {
      viewAspectRatio = 3 / 2;
    }
    // Initialize microphone and camera
    _isMicEnabled = isMicEnabled;
    _isVideoEnabled = isVideoEnabled;
    await _initAgoraRtcEngine(appId);
    _addAgoraEventHandlers(channelName: channelName);
    final options = ChannelMediaOptions(
      publishLocalAudio: _isMicEnabled,
      publishLocalVideo: _isVideoEnabled,
    );
    await _agoraEngine.joinChannel(
      token,
      channelName,
      null,
      0,
      options,
    );
  }

  Future<void> disposeAgora() async {
    _users.clear();
    await _agoraEngine.leaveChannel();
  }

  Future<void> _initAgoraRtcEngine(String appId) async {
    _agoraEngine = await RtcEngine.create(appId);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.orientationMode = VideoOutputOrientationMode.Adaptative;
    await _agoraEngine.setVideoEncoderConfiguration(configuration);
    await _agoraEngine.enableAudio();
    await _agoraEngine.enableVideo();
    await _agoraEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _agoraEngine.setClientRole(ClientRole.Broadcaster);
    await _agoraEngine.muteLocalAudioStream(!_isMicEnabled);
    await _agoraEngine.muteLocalVideoStream(!_isVideoEnabled);
  }

  void _addAgoraEventHandlers({required String channelName}) =>
      _agoraEngine.setEventHandler(
        RtcEngineEventHandler(
          error: (code) {
            final info = 'LOG::onError: $code';
            debugPrint(info);
          },
          joinChannelSuccess: (channel, uid, elapsed) {
            final info = 'LOG::onJoinChannel: $channel, uid: $uid';
            debugPrint(info);
            _currentUid = uid;
            _users.add(
              AgoraUser(
                uid: uid,
                isAudioEnabled: _isMicEnabled,
                isVideoEnabled: _isVideoEnabled,
                view: const rtc_local_view.SurfaceView(),
              ),
            );
            notifyListeners();
          },
          firstLocalAudioFrame: (elapsed) {
            final info = 'LOG::firstLocalAudio: $elapsed';
            debugPrint(info);
            for (AgoraUser user in _users) {
              if (user.uid == _currentUid) {
                user.isAudioEnabled = _isMicEnabled;
                notifyListeners();
              }
            }
          },
          firstLocalVideoFrame: (width, height, elapsed) {
            debugPrint('LOG::firstLocalVideo');
            for (AgoraUser user in _users) {
              if (user.uid == _currentUid) {
                user
                  ..isVideoEnabled = _isVideoEnabled
                  ..view = const rtc_local_view.SurfaceView(
                    renderMode: VideoRenderMode.Hidden,
                  );
                notifyListeners();
              }
            }
          },
          leaveChannel: (stats) {
            debugPrint('LOG::onLeaveChannel');
            _users.clear();
            notifyListeners();
          },
          userJoined: (uid, elapsed) {
            final info = 'LOG::userJoined: $uid';
            debugPrint(info);
            _users.add(
              AgoraUser(
                uid: uid,
                view: rtc_remote_view.SurfaceView(
                  channelId: channelName,
                  uid: uid,
                ),
              ),
            );
            notifyListeners();
          },
          userOffline: (uid, elapsed) {
            final info = 'LOG::userOffline: $uid';
            debugPrint(info);
            AgoraUser? userToRemove;
            for (AgoraUser user in _users) {
              if (user.uid == uid) {
                userToRemove = user;
              }
            }
            _users.remove(userToRemove);
            notifyListeners();
          },
          firstRemoteAudioFrame: (uid, elapsed) {
            final info = 'LOG::firstRemoteAudio: $uid';
            debugPrint(info);
            for (AgoraUser user in _users) {
              if (user.uid == uid) {
                user.isAudioEnabled = true;
                notifyListeners();
              }
            }
          },
          firstRemoteVideoFrame: (uid, width, height, elapsed) {
            final info = 'LOG::firstRemoteVideo: $uid ${width}x $height';
            debugPrint(info);
            for (AgoraUser user in _users) {
              if (user.uid == uid) {
                user
                  ..isVideoEnabled = true
                  ..view = rtc_remote_view.SurfaceView(
                    channelId: channelName,
                    uid: uid,
                  );
                notifyListeners();
              }
            }
          },
          remoteVideoStateChanged: (uid, state, reason, elapsed) {
            final info = 'LOG::remoteVideoStateChanged: $uid $state $reason';
            debugPrint(info);
            for (AgoraUser user in _users) {
              if (user.uid == uid) {
                user.isVideoEnabled = state != VideoRemoteState.Stopped;
                notifyListeners();
              }
            }
          },
          remoteAudioStateChanged: (uid, state, reason, elapsed) {
            final info = 'LOG::remoteAudioStateChanged: $uid $state $reason';
            debugPrint(info);
            for (AgoraUser user in _users) {
              if (user.uid == uid) {
                user.isAudioEnabled = state != AudioRemoteState.Stopped;
                notifyListeners();
              }
            }
          },
        ),
      );

  Future<void> onCallEnd(BuildContext context) async {
    await _agoraEngine.leaveChannel();
    await _agoraEngine.destroy();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void onToggleAudio() {
    _isMicEnabled = !_isMicEnabled;

    for (AgoraUser user in _users) {
      if (user.uid == _currentUid) {
        user.isAudioEnabled = _isMicEnabled;
      }
    }

    _agoraEngine.muteLocalAudioStream(!_isMicEnabled);
    notifyListeners();
  }



  void onToggleCamera() {
    _isVideoEnabled = !_isVideoEnabled;
    for (AgoraUser user in _users) {
      if (user.uid == _currentUid) {
        user.isVideoEnabled = _isVideoEnabled;
      }
    }
    _agoraEngine.muteLocalVideoStream(!_isVideoEnabled);
    notifyListeners();
  }

  void onSwitchCamera() => _agoraEngine.switchCamera();

  List<int> createLayout(int n) {
    int rows = (sqrt(n).ceil());
    int columns = (n / rows).ceil();

    List<int> layout = List<int>.filled(rows, columns);
    int remainingScreens = rows * columns - n;

    for (int i = 0; i < remainingScreens; i++) {
      layout[layout.length - 1 - i] -= 1;
    }

    return layout;
  }
}
