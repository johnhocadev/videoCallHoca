import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_call_app/pages/call/presentation/widget/tool_bar.dart';
import 'package:video_call_app/pages/call/presentation/widget/view_panel.dart';
import 'package:video_call_app/pages/call/presentation/widget/view_rows.dart';
import 'package:video_call_app/pages/call/view_model/provider/call_provider.dart';

class CallingPage extends ConsumerWidget {
  const CallingPage(
      {required this.enabledVideo, this.channelName, this.roleType, Key? key})
      : super(key: key);

  final String? channelName;
  final ClientRoleType? roleType;
  final bool enabledVideo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(
      callingPageProvider(
        CallingPageInput(
            enabledVideo: enabledVideo,
            channelName: channelName,
            roleType: roleType),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Inside Channel"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              provider.toggleViewPanel();
            },
            icon: Icon(Icons.info_outline),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ViewRows(roleType: roleType, channelName: channelName, provider: provider),
          ViewPanel(provider: provider),
          Positioned(
            child: ToolBar(provider: provider, context: context),
            bottom: 10,
          )
        ],
      ),
    );
  }
}



