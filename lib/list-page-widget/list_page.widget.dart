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
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  final TextEditingController _addTextController = TextEditingController();
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
  final TextEditingController _editTextController = TextEditingController();

  // Todo: this should come from api
  List<Item> items = [
    Item(1, 1, 'costco item'),
    Item(2, 2, 'safeway item'),
  ];

  // remove: this is a temporary id generator
  int _counter = 3;

  Future<void> showEditItemDialog(BuildContext context, Item item) async {
    String title = 'Edit Item';
    _editTextController.text = item.name;

    return await _showDialog(
      context,
      title,
      _getDialogForm(_editFormKey, _editTextController),
      <Widget>[
        _getDefaultCancelBtn(context),
        _getOkBtn(
          context,
          _editFormKey,
          _editTextController,
          () => _editItem(_editTextController.text, item.id as int),
        ),
      ],
    );
  }

  Future<void> showAddItemDialog(BuildContext context, int shopId) async {
    String title = 'Add Item';

    return await _showDialog(
      context,
      title,
      _getDialogForm(_addFormKey, _addTextController),
      <Widget>[
        _getDefaultCancelBtn(context),
        _getOkBtn(
          context,
          _addFormKey,
          _addTextController,
          () => _addItem(
            _addTextController.text,
            shopId,
          ),
        ),
      ],
    );
  }

  void _addItem(String name, int shopId) {
    setState(() {
      // Todo: should call api
      items.add(Item(_counter, shopId, name));
      _counter++;
    });
  }

  void _editItem(String newName, int itemId) {
    setState(() {
      // Todo: should call api
      for (final i in items) {
        if (i.id == itemId) {
          final index = items.indexOf(i);

          Item newItem = Item(i.id, i.storeId, newName);
          items.removeAt(index);
          items.insert(index, newItem);
        }
      }
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
          return ListTile(
            title: Text(filteredList[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await showEditItemDialog(
                      context,
                      filteredList[index],
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteItem(filteredList[index].id),
                ),
              ],
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

/* PRIVATE
---------------------------------------------------------------------*/
Future<void> _showDialog(
  BuildContext context,
  String title,
  Form dialogForm,
  List<Widget> actionBtns,
) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: dialogForm,
            title: Text(title),
            actions: actionBtns,
          );
        });
      });
}

Form _getDialogForm(
  GlobalKey<FormState> formKey,
  TextEditingController textController,
) {
  String placeholder = 'Enter item name';
  String validationMsg = '*Item name is required';

  return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: textController,
            validator: (value) {
              return value!.isNotEmpty ? null : validationMsg;
            },
            decoration: InputDecoration(
              hintText: placeholder,
            ),
          ),
        ],
      ));
}

ElevatedButton _getDefaultCancelBtn(BuildContext context) {
  return ElevatedButton(
    onPressed: () => Navigator.of(context).pop(),
    child: const Text('Cancel'),
    style: ElevatedButton.styleFrom(
      primary: Colors.red,
    ),
  );
}

ElevatedButton _getOkBtn(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController textController,
  VoidCallback actionFn,
) {
  return ElevatedButton(
    onPressed: () => {
      if (formKey.currentState!.validate())
        {
          actionFn(),
          textController.clear(),
          Navigator.of(context).pop(),
        }
    },
    child: const Text('OK'),
  );
}
