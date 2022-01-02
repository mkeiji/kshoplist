class Item {
  final int? id;
  final int storeId;
  String name;

  Item(this.id, this.storeId, this.name);
  Item.noId(this.storeId, this.name): id = null;
  Item.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] as int,
        storeId = json['storeId'] as int,
        name = json['name'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': id,
        'storeId': storeId,
        'name': name,
      };
}
