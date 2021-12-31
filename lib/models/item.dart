class Item {
  final int? id;
  final String name;
  final int storeId;

  Item(this.id, this.name, this.storeId);
  Item.noId(this.name, this.storeId): id = null;
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
