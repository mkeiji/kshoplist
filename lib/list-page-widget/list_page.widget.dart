import 'package:flutter/material.dart';
import 'package:kshoplist/models/item.dart';
import 'package:kshoplist/models/store.dart';

class ListPageWidget extends StatefulWidget {
  const ListPageWidget({Key? key, required this.shop}) : super(key: key);

  final Shop shop;

  @override
  State<ListPageWidget> createState() => _ListPageWidgetState();
}

/* STATE
---------------------------------------------------------------------*/
class _ListPageWidgetState extends State<ListPageWidget> {
  // Todo: this should come from api
  List<Item> items = [];
  int _counter = 0;

  void _addItem() {
    setState(() {
      // Todo: should call api
      items.add(Item(_counter, 'item $_counter', 1));
      _counter++;
    });
  }

  void _deleteItem(int? id) {
    setState(() {
      // Todo: should call api
      items.removeWhere((Item item) => item.id == id);
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = '${widget.shop.name} List';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 3,
          color: Colors.lightBlue,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(items[index].id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
