import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_call_app/flutter_flow/flutter_flow_util.dart';
import 'package:video_call_app/pages/call/presentation/widget/calling_page.dart';
import 'package:video_call_app/pages/call/presentation/widget/switch_button.dart';
import 'package:video_call_app/pages/call/view_model/provider/call_provider.dart';

const appId = '979ff86d7339456595fd0661b0fc081e';
const token =
    '007eJxTYEjPzpnotaLo+87wpGcJc9vLZdMPPekzDHx23+LZ/cQJMxIUGFKTU1NSU82TUwzTTEyMU80tzM3NDc0Sk40NDVKMLAzNnrIeTGkIZGQ4uzmKlZEBAkF8ToayzJTU/OTEnBwGBgCvdiPt';

class CallPage extends ConsumerWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callTool = ref.watch(callProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        actions: [
          Center(
              child: Text(
            "Video",
            style: TextStyle(fontSize: 20),
          )),
          SizedBox(
            width: 10,
          ),
          SwitcherWidget(switcher: callTool.switcher),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final item = users[index];
          return InkWell(
              onTap: () {
                // context.goNamedAuth('CallPage', context.mounted,queryParameters:  );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CallingPage()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                height: 30,
                child: Text(item.name),
              ));
        },
      ),
    );
  }
}

List<UserModel> users = [
  UserModel.name(name: 'Elmurod aka', uid: 1),
];

class UserModel {
  final String name;
  final int uid;

  UserModel.name({required this.name, required this.uid});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          uid == other.uid;

  @override
  int get hashCode => name.hashCode ^ uid.hashCode;
}
