class Shop {
  final int? id;
  final String name;
  final String? img;

  Shop(this.id, this.name, this.img);
  Shop.noId(this.name, this.img) : id = null;
  Shop.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        img = json['img'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': id,
        'text': name,
        'img': img,
      };
}
