class WoWSet {
  final String id;
  final String name;
  final int block;

  WoWSet({required this.id, required this.name, required this.block});

  WoWSet.fromDb(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      block = map['block'];
}
