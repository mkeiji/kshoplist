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
  List<Item> items = [];
  int _counter = 0;

  Future<void> showAddItemDialog(BuildContext context) async {
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
                return value!.isNotEmpty ? null : placeholder;
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
            _addItem(input),
            _textEditingController.clear(),
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

  void _addItem(String? name) {
    String itemName = 'item $_counter';

    if (name != null) {
      itemName = name;
    }

    setState(() {
      // Todo: should call api
      items.add(Item(_counter, itemName, 1));
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
        onPressed: () async {
          await showAddItemDialog(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
