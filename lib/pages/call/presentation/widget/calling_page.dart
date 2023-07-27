import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'package:video_call_app/core/constant/data/app_data.dart';

class CallingPage extends ConsumerStatefulWidget {
  final String? channelName;
  final ClientRoleType? roleType;
  final bool enabledVideo;

  const CallingPage(
      {required this.enabledVideo, this.channelName, this.roleType, Key? key})
      : super(key: key);

  @override
  ConsumerState createState() => _CallingPageState();
}

class _CallingPageState extends ConsumerState<CallingPage> {
  final _users = <int>[];
  final _infoString = <String>[];
  bool muted = false;
  bool viewPanel = false;
  late bool enableVideo;

  late RtcEngine _engine;

  @override
  void initState() {
    enableVideo = widget.enabledVideo;

    _initialize();

    super.initState();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Future<void> _initialize() async {
    if (appId.isEmpty) {
      _infoString.add('App ID is missing, please provide you app ID');
      _infoString.add('Agora engine is not starting');
      return;
    }
    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    if (enableVideo) {

      await _engine.enableVideo();
    }
    await _engine
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine.setClientRole(role: widget.roleType!);
    _addAgoraEventHandler();
    _engine.joinChannel(
      token: token,
      channelId: widget.channelName!,
      uid: 0,
      options: ChannelMediaOptions(),
    );
  }

  void _addAgoraEventHandler() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(onError: (code, text) {
        setState(() {
          final info = 'Error: $code';
          _infoString.add(info);
        });
      }, onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint("local user ${connection.localUid} joined");
        setState(() {
          final info =
              'Join channel: ${connection.channelId}, UID: ${connection.localUid}';
          _infoString.add(info);
        });
      }, onLeaveChannel: (RtcConnection connection, stats) {
        setState(() {
          _infoString.add('Leave Channel');
          _users.clear();
        });
      }, onUserJoined: (RtcConnection connection, remoteUID, elapsed) {
        final info = 'UserJoined: $remoteUID';
        _infoString.add(info);
      }, onUserOffline:
          (RtcConnection connection, remoteUid, UserOfflineReasonType type) {
        final info = '$remoteUid goes offline because ${type.name}';
        _infoString.add(info);
        _users.remove(remoteUid);
      }),
    );
  }

  Widget _viewRows() {
    final List<StatefulWidget> list = [];
    if (widget.roleType == ClientRoleType.clientRoleBroadcaster) {
      list.add(AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      ));
    }
    for (var uid in _users) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: uid),
          connection: RtcConnection(channelId: '${widget.channelName}'),
        ),
      );
    }
    final views = list;
    return Column(
      children: List.generate(
        views.length,
        (index) => Expanded(
          child: views[index],
        ),
      ),
    );
  }

  Widget _toolBar() {
    if (widget.roleType == ClientRoleType.clientRoleAudience) return SizedBox();
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: EdgeInsets.all(12.0),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                setState(() {
                  muted = !muted;
                });
                _engine.muteLocalAudioStream(muted);
              });
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
              enableVideo ? Icons.camera_alt : Icons.camera,
              color: enableVideo ? Colors.black : Colors.blue,
              size: 35,
            ),
            onPressed: () {
              setState(() {
                if (!enableVideo) {
                  Permission.camera
                      .request()
                      .then((value) => _engine.enableVideo());
                  enableVideo = true;
                } else {
                  setState(() {
                    _engine.disableVideo();
                    enableVideo = false;
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _viewPanel() {
    return Visibility(
      visible: viewPanel,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: ListView.builder(
                reverse: true,
                itemCount: _infoString.length,
                itemBuilder: (context, index) {
                  if (_infoString.isEmpty) {
                    return Text(
                      'NO Data',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _infoString[index],
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ))
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Inside Channel"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                viewPanel = !viewPanel;
              });
            },
            icon: Icon(Icons.info_outline),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _viewRows(),
          _viewPanel(),
          Positioned(
            child: _toolBar(),
            bottom: 10,
          )
        ],
      ),
    );
  }
}

// Instantiate the client

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }
//
//   Future<void> initAgora() async {
//     // retrieve permissions
//     await [Permission.microphone, Permission.camera].request();
//
//     //create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//       ),
//     );
//
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//
//     await _engine.joinChannel(
//       token: token,
//       channelId: 'videocall',
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   // Create UI with local view and remote view
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Agora Video Call'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? AgoraVideoView(
//                   controller: VideoViewController(
//                     rtcEngine: _engine,
//                     canvas: const VideoCanvas(uid: 0),
//                   ),
//                 )
//                     : const CircularProgressIndicator(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: const RtcConnection(channelId: 'videocall'),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
