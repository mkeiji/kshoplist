import 'package:kshoplist/models/item.dart';

class Kmsg {
  String type;
  String action;
  List<Item> items;

  Kmsg(this.type, this.action, this.items);

  factory Kmsg.fromJson(Map<String, dynamic> json) {
    var itemsList = [];
    if (json['items'] != null) {
      itemsList = json['items'] as List;
    }

    String type = json['type'];
    String action = json['action'];
    List<Item> items = itemsList.map((i) => Item.fromJson(i)).toList();

    return Kmsg(type, action, items);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "type": type,
      "action": action,
      "items": items,
    };
    return data;
  }
}
