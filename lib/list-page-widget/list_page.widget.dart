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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  // Todo: this should come from api
  List<Item> items = [
    Item(1, 'costco item', 1),
    Item(2, 'safeway item', 2),
  ];
  int _counter = 0;

  Future<void> showAddItemDialog(BuildContext context, int shopId) async {
    String placeholder = 'Enter item name';
    String? input;

    Form dialogForm = Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _textEditingController,
              validator: (value) {
                return value!.isNotEmpty ? null : '*Item name is required';
              },
              onChanged: (change) => {input = change},
              decoration: InputDecoration(
                hintText: placeholder,
              ),
            ),
          ],
        ));

    ElevatedButton cancelBtn = ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Cancel'),
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
      ),
    );

    ElevatedButton okBtn = ElevatedButton(
      onPressed: () => {
        if (_formKey.currentState!.validate())
          {
            if (input != null)
              {
                _addItem(input as String, shopId),
                _textEditingController.clear(),
              },
            Navigator.of(context).pop(),
          }
      },
      child: const Text('OK'),
    );

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: dialogForm,
              title: const Text('Add Item'),
              actions: <Widget>[
                cancelBtn,
                okBtn,
              ],
            );
          });
        });
  }

  void _addItem(String name, int shopId) {
    setState(() {
      // Todo: should call api
      items.add(Item(_counter, name, shopId));
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
    List<Item> filteredList =
        items.where((Item i) => i.storeId == widget.shop.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.separated(
        itemCount: filteredList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 3,
          color: Colors.lightBlue,
        ),
        itemBuilder: (context, index) {
          // Todo: add Edit feature
          return ListTile(
            title: Text(filteredList[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(filteredList[index].id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showAddItemDialog(context, widget.shop.id as int);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
