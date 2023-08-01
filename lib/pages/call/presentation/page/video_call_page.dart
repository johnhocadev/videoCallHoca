import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/presentation/widget/agora_video_layout.dart';
import 'package:video_call_app/pages/call/presentation/widget/call_actions_row.dart';
import 'package:video_call_app/pages/call/view_model/provider/video_call_prov.dart';

class VideoCallPage extends ConsumerStatefulWidget {
  const VideoCallPage({

    required this.appId,
    required this.token,
    required this.channelName,
    required this.isMicEnabled,
    required this.isVideoEnabled,
    super.key,
  });

  final String appId;
  final String token;
  final String channelName;
  final bool isMicEnabled;
  final bool isVideoEnabled;

  @override
  ConsumerState createState() =>
      _VideoCallPageState();
}

class _VideoCallPageState extends ConsumerState<VideoCallPage> {
  @override
  void initState() {
    super.initState();
    ref.read(videoCallStateNotifierProvider).initialize(
      widget.appId,
      widget.token,
      widget.channelName,
      widget.isMicEnabled,
      widget.isVideoEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoCallState = ref.watch(videoCallStateNotifierProvider);
    final users = videoCallState.users;
    final viewAspectRatio = videoCallState.viewAspectRatio;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        centerTitle: false,
        title: Row(
          children: [
            const Icon(
              Icons.meeting_room_rounded,
              color: Colors.white54,
            ),
            const SizedBox(width: 6.0),
            const Text(
              'Channel name: ',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16.0,
              ),
            ),
            Text(
              widget.channelName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white54,
                ),
                const SizedBox(width: 6.0),
                Text(
                  users.length.toString(),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    final isPortrait = orientation == Orientation.portrait;
                    if (users.isEmpty) {
                      return const SizedBox();
                    }
                    WidgetsBinding.instance.addPostFrameCallback(
                            (_) =>
                        ref.read(videoCallStateNotifierProvider).viewAspectRatio = isPortrait ? 2 / 3 : 3 / 2);


                    final layoutViews = ref.read(videoCallStateNotifierProvider.notifier)
                        .createLayout(users.length);
                    return AgoraVideoLayout(
                    users: users,
                    views: layoutViews
                    ,
                    viewAspectRatio
                    :
                    viewAspectRatio
                    ,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CallActionsRow(
                isMicEnabled: videoCallState.isMicEnabled,
                isVideoEnabled: videoCallState.isVideoEnabled,
                onCallEnd: () =>
                    ref.read(videoCallStateNotifierProvider).onCallEnd(
                        context),
                onToggleAudio: () =>
                    ref.read(videoCallStateNotifierProvider)
                        .onToggleAudio(),
                onToggleCamera: () =>
                    ref.read(videoCallStateNotifierProvider)
                        .onToggleCamera(),
                onSwitchCamera: () =>
                    ref.read(videoCallStateNotifierProvider)
                        .onSwitchCamera(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


