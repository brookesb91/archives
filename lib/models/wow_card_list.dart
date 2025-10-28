class WoWCardList {
  final int id;
  final String name;

  WoWCardList({required this.id, required this.name});

  WoWCardList.fromDb(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'];
}
