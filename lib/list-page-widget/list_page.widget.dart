import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kshoplist/models/item.dart';
import 'package:kshoplist/models/kmsg.dart';
import 'package:kshoplist/models/store.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws/1'),
  );

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = '${widget.shop.name} List';
    int storeId = widget.shop.id as int;
    List<Item> filteredList = [];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder(
        stream: _channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var json = jsonDecode(snapshot.data as String);
            Kmsg msg = Kmsg.fromJson(json);
            List<Item> items = msg.items;
            filteredList = _filterList(items, storeId);
          } else {
            debugPrint('hasData: ${snapshot.hasData}');
          }

          return ListView.separated(
            itemCount: filteredList.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 3,
              color: Colors.lightBlue,
            ),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredList[index].name as String),
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

  Future<void> showEditItemDialog(BuildContext context, Item item) async {
    String title = 'Edit Item';
    _editTextController.text = item.name as String;

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
          () => _editItem(_editTextController.text, item),
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
    Kmsg newMsg = Kmsg(
      "Request",
      "POST",
      [Item.noId(shopId, name)],
    );
    _channel.sink.add(jsonEncode(newMsg.toJson()));
  }

  void _editItem(String newName, Item item) {
    Item newItem = Item(item.id, item.storeId, newName);
    Kmsg newMsg = Kmsg(
      "Request",
      "PUT",
      [newItem],
    );
    _channel.sink.add(jsonEncode(newMsg.toJson()));
  }

  void _deleteItem(int? id) {
    Item newItem = Item.justId(id);
    Kmsg newMsg = Kmsg(
      "Request",
      "DELETE",
      [newItem],
    );
    _channel.sink.add(jsonEncode(newMsg.toJson()));
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

List<Item> _filterList(List<Item> list, int storeId) {
  return list.where((Item i) => i.storeId == storeId).toList();
}
