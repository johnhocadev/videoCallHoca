enum Words {
  upgrade,
}
extension MyWords on Words {
  String tr([int? key]) => "$name${key ?? "" }";
}
