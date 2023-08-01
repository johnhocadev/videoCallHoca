// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:video_call_app/core/constant/data/app_data.dart';
// import 'package:video_call_app/pages/call/presentation/page/video_call_page.dart';
//
// class PreJoiningDialog extends StatefulWidget {
//   const PreJoiningDialog({
//     super.key,
//     required this.token,
//     required this.channelName,
//   });
//
//   final String token;
//   final String channelName;
//
//   @override
//   State<PreJoiningDialog> createState() => _PreJoiningDialogState();
// }
//
// class _PreJoiningDialogState extends State<PreJoiningDialog> {
//   bool _isMicEnabled = false;
//   bool _isCameraEnabled = false;
//   bool _isJoining = false;
//
//   Future<void> _getMicPermissions() async {
//     if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
//       final micPermission = await Permission.microphone.request();
//       if (micPermission == PermissionStatus.granted) {
//         setState(() => _isMicEnabled = true);
//       }
//     } else {
//       setState(() => _isMicEnabled = !_isMicEnabled);
//     }
//   }
//
//   Future<void> _getCameraPermissions() async {
//     if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
//       final cameraPermission = await Permission.camera.request();
//       if (cameraPermission == PermissionStatus.granted) {
//         setState(() => _isCameraEnabled = true);
//       }
//     } else {
//       setState(() => _isCameraEnabled = !_isCameraEnabled);
//     }
//   }
//
//   Future<void> _getPermissions() async {
//     await _getMicPermissions();
//     await _getCameraPermissions();
//   }
//
//   Future<void> _joinCall() async {
//     setState(() => _isJoining = true);
//     final appId = Constants().appId;
//
//     setState(() => _isJoining = false);
//     if (context.mounted) {
//       Navigator.of(context).pop();
//       await Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => VideoCallPage(
//             appId: appId,
//             token: widget.token,
//             channelName: widget.channelName,
//             isMicEnabled: _isMicEnabled,
//             isVideoEnabled: _isCameraEnabled,
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     _getPermissions();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       child: SizedBox(
//         width: 350.0,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Joining Call',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//               const Text(
//                 'You are about to join a video call. Please set you mic and camera preferences.',
//               ),
//               const SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       InkWell(
//                         borderRadius: BorderRadius.circular(32),
//                         onTap: () {
//                           if (_isMicEnabled) {
//                             setState(() => _isMicEnabled = false);
//                           } else {
//                             _getMicPermissions();
//                           }
//                         },
//                         child: CircleAvatar(
//                           backgroundColor: Colors.redAccent,
//                           radius: 32.0,
//                           child: Icon(
//                             _isMicEnabled
//                                 ? Icons.mic_rounded
//                                 : Icons.mic_off_rounded,
//                             size: 32,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text('Mic: ${_isMicEnabled ? 'On' : 'Off'}'),
//                     ],
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       InkWell(
//                         borderRadius: BorderRadius.circular(32),
//                         onTap: () {
//                           if (_isCameraEnabled) {
//                             setState(() => _isCameraEnabled = false);
//                           } else {
//                             _getCameraPermissions();
//                           }
//                         },
//                         child: CircleAvatar(
//                           backgroundColor: Colors.redAccent,
//                           radius: 32.0,
//                           child: Icon(
//                             _isCameraEnabled
//                                 ? Icons.videocam_rounded
//                                 : Icons.videocam_off_rounded,
//                             size: 32,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text('Camera: ${_isCameraEnabled ? 'On' : 'Off'}'),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   SizedBox(
//                     width: 120.0,
//                     child: _isJoining
//                         ? const CircularProgressIndicator()
//                         : ElevatedButton(
//                             onPressed: _joinCall,
//                             child: const Text('Join'),
//                           ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/view_model/provider/pre_joining_provider.dart';

class PreJoiningDialog extends ConsumerWidget {
  const PreJoiningDialog({
    super.key,
    required this.token,
    required this.channelName,
  });

  final String token;
  final String channelName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(preJoiningDialogProvider);

    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 350.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Joining Call',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'You are about to join a video call. Please set your mic and camera preferences.',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () => notifier.isMicEnabled
                            ? notifier.isMicEnabled = false
                            : notifier.getMicPermissions(),
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          radius: 32.0,
                          child: Icon(
                            notifier.isMicEnabled
                                ? Icons.mic_rounded
                                : Icons.mic_off_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Mic: ${notifier.isMicEnabled ? 'On' : 'Off'}'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () => notifier.isCameraEnabled
                            ? notifier.isCameraEnabled = false
                            : notifier.getCameraPermissions(),
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          radius: 32.0,
                          child: Icon(
                            notifier.isCameraEnabled
                                ? Icons.videocam_rounded
                                : Icons.videocam_off_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          'Camera: ${notifier.isCameraEnabled ? 'On' : 'Off'}'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120.0,
                    child: notifier.isJoining
                        ? Center(child: const CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () => notifier.joinCall(
                              channelName: channelName,
                              context: context,
                              token: token,
                            ),
                            child: const Text('Join'),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
