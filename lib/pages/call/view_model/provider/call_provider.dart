import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/view_model/call_vm.dart';
import 'package:video_call_app/pages/call/view_model/calling_vm.dart';

final callProvider = ChangeNotifierProvider((ref) => CallVM());

final callingPageProvider = ChangeNotifierProvider.autoDispose
    .family<CallingPageProvider, CallingPageInput>((ref, input) {
  return CallingPageProvider(
      enabledVideo: input.enabledVideo,
      channelName: input.channelName,
      roleType: input.roleType);
});

class CallingPageInput {
  final bool enabledVideo;
  final String? channelName;
  final ClientRoleType? roleType;

  CallingPageInput(
      {required this.enabledVideo, this.channelName, this.roleType});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallingPageInput &&
          runtimeType == other.runtimeType &&
          enabledVideo == other.enabledVideo &&
          channelName == other.channelName &&
          roleType == other.roleType;

  @override
  int get hashCode =>
      enabledVideo.hashCode ^ channelName.hashCode ^ roleType.hashCode;
}



