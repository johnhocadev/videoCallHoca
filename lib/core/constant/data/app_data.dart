const appId = '979ff86d7339456595fd0661b0fc081e';
const token = '007eJxTYDDfty3DpGjavdfP4uQ7j5wx37m3UfPutfptN+SsPcvn83EoMKQmp6akpponpximmZgYp5pbmJubG5olJhsbGqQYWRiafVx+OKUhkJGh8oM8CyMDBIL4rAxlmSmp+QwMAPylIcE=';
List<UserModel> users = [
  UserModel.name(name: 'Elmurod aka', channelName: 'videocall'),
];

class UserModel {
  final String name;
  final String channelName;

  UserModel.name({required this.name, required this.channelName});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          channelName == other.channelName;

  @override
  int get hashCode => name.hashCode ^ channelName.hashCode;
}
