import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/core/constant/data/app_data.dart';
import 'package:video_call_app/pages/call/presentation/widget/calling_page.dart';
import 'package:video_call_app/pages/call/presentation/widget/switch_button.dart';
import 'package:video_call_app/pages/call/view_model/provider/call_provider.dart';
import 'dart:async';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';

class CallPage extends ConsumerStatefulWidget {
  const CallPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CallPageState();
}

class _CallPageState extends ConsumerState<CallPage> {
  final _channelController = TextEditingController();
  ClientRoleType? _role = ClientRoleType.clientRoleBroadcaster;

  @override
  void dispose() {
    _channelController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        actions: [
          Center(
              child: Text(
            "Video",
            style: TextStyle(fontSize: 20),
          )),
          SizedBox(width: 10),
          SwitcherWidget(switcher: ref.read(callProvider).switcher),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Column(
            children: [
              RadioListTile(
                value: ClientRoleType.clientRoleBroadcaster,
                groupValue: _role,
                onChanged: (ClientRoleType? role) {
                  _role = role;
                  setState(() {

                  });
                },
                title: Text('Broadcaster'),
              ),
              RadioListTile(
                value: ClientRoleType.clientRoleAudience,
                groupValue: _role,
                onChanged: (ClientRoleType? role) {
                  _role = role;
                  setState(() {

                  });

                },
                title: Text('Audience'),
              ),
            ],
          ),
          Text(
            'Channel Lists',
            style: TextStyle(fontSize: 25),
          ),
          InkWell(
            onTap: ()async {
            await  onJoin(users[0].channelName);
            },
            child: Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text(
                users[0].name,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onJoin(String channelName) async {
    await _handleCameraAndMic(Permission.microphone);

    if (ref.watch(callProvider).switcher) {
      await _handleCameraAndMic(Permission.camera);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallingPage(
          enabledVideo: ref.watch(callProvider).switcher,
          channelName: channelName,
          roleType: _role,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = permission.request();
    log(status.toString());
  }
}
