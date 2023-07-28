import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/pages/call/presentation/page/calling_page.dart';
import 'package:video_call_app/pages/call/presentation/widget/custom_radio.dart';
import 'package:video_call_app/pages/call/presentation/widget/switch_button.dart';
import 'package:video_call_app/pages/call/view_model/provider/call_provider.dart';
import 'dart:async';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';

class CallPage extends ConsumerWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ModalRoute.of(context)?.settings.arguments as RemoteMessage?;
    final callTool = ref.watch(callProvider);
    callTool.channelController.text = message?.notification?.body ?? '';


    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        actions: [
          Center(
            child: Text(
              "Video",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(width: 10),
          SwitcherWidget(switcher: callTool.switcher),
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
                controller: callTool.channelController,
                decoration: InputDecoration(
                  errorText: callTool.validator ? 'Channel is mandatory' : null,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  hintText: 'Channel name',
                ),
              ),
              SizedBox(height: 20),
              CustomRadio(
                  clientValue: ClientRoleType.clientRoleBroadcaster,
                  clientGroupValue: callTool.role,
                  updateRole: (role) => callTool.updateRole(role),
                  title: 'Broadcast'),
              CustomRadio(
                  clientValue: ClientRoleType.clientRoleAudience,
                  clientGroupValue: callTool.role,
                  updateRole: (role) => callTool.updateRole(role),
                  title: 'Audience'),
              ElevatedButton(
                onPressed: () => onJoin(
                    callTool.channelController.text.trim(), ref, context),
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

  Future<void> onJoin(
      String channelName, WidgetRef ref, BuildContext context) async {
    final callTool = ref.read((callProvider));
    callTool.channelController.text.isEmpty
        ? callTool.updateValidator(true)
        : callTool.updateValidator(false);

    if (callTool.channelController.text.isNotEmpty) {
      await handleCameraAndMic(Permission.microphone);

      if (callTool.switcher) {
        await handleCameraAndMic(Permission.camera);
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallingPage(
            enabledVideo: callTool.switcher,
            channelName: channelName,
            roleType: callTool.role,
          ),
        ),
      );
    }
  }

  Future<void> handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }
}

