const appId = 'ecedee7cd1f443e7877716ac310d2816';
const token = '007eJxTYFjLp3PsK1fXBa1oZuNjFvJmfV/2VwnnM081uSFerHXYZrYCQ2pyakpqqnlyimGaiYlxqrmFubm5oVlisrGhQYqRhaHZbtFDKQ2BjAyCX3czMEIhiM/JUJaZkpqfnJiTw8AAAEh6H5c=';
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
