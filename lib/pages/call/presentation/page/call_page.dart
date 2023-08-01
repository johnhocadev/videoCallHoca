import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  bool _validator = false;
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
          SwitcherWidget(switcher: ref.watch(callProvider).switcher),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              Image.asset('assets/images/video.webp'),
              SizedBox(height: 20),
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                    errorText: _validator ? 'Channel is mandatory' : null,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    hintText: 'Channel name'),
              ),
              SizedBox(height: 20),
              RadioListTile(
                value: ClientRoleType.clientRoleBroadcaster,
                groupValue: _role,
                onChanged: (ClientRoleType? role) {
                  _role = role;
                  setState(() {});
                },
                title: Text('Broadcaster'),
              ),
              RadioListTile(
                value: ClientRoleType.clientRoleAudience,
                groupValue: _role,
                onChanged: (ClientRoleType? role) {
                  setState(() {
                    _role = role;
                  });
                },
                title: Text('Audience'),
              ),
              ElevatedButton(
                onPressed: () => onJoin(_channelController.text.trim()),
                child: Text("Join"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin(String channelName) async {
    _channelController.text.isEmpty ? _validator = true : _validator = false;
    setState(() {});

    if(_channelController.text.isNotEmpty){
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

  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = permission.request();
    log(status.toString());
  }
}
