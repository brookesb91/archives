class WoWCard {
  final int id;
  final String name;
  final String type;
  final String faction;
  final String setcode;
  final String setname;
  final int no;
  final String? rules;
  final String rarity;
  final int? cost;
  final bool instant;
  final String? subtype;
  final int block;
  final String image;
  final String version;
  final String? artist;
  final String? flavour;

  WoWCard({
    required this.id,
    required this.name,
    required this.type,
    required this.faction,
    required this.setcode,
    required this.setname,
    required this.no,
    this.rules,
    required this.rarity,
    this.cost,
    required this.instant,
    this.subtype,
    required this.block,
    required this.image,
    required this.version,
    this.artist,
    this.flavour,
  });

  WoWCard.fromDb(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      type = map['type'],
      faction = map['faction'],
      setcode = map['setcode'],
      setname = map['setname'],
      no = map['no'],
      rules = map['rules'],
      rarity = map['rarity'],
      cost = map['cost'],
      instant = map['instant'] == 1,
      subtype = map['subtype'],
      block = map['block'],
      image = map['image'],
      version = map['version'],
      artist = map['artist'],
      flavour = map['flavour'];
}
