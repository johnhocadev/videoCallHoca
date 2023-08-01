import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_call_app/pages/call/view_model/video_call_vm.dart';

final videoCallStateNotifierProvider = ChangeNotifierProvider<VideoCallStateNotifier>((ref) {
  return VideoCallStateNotifier();
});
