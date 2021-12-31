import 'package:flutter/material.dart';
import 'package:kshoplist/models/item.dart';
import 'package:kshoplist/models/store.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static const String _title = 'KShopList';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  // Todo: this should come from api
  List<Shop> shops = [
    Shop(1, 'Costco', '../assets/home-assets/costco-rz.png'),
    Shop(2, 'Safeway', '../assets/home-assets/safeway-rz.png'),
    Shop(3, 'Superstore', '../assets/home-assets/superstore-rz.png'),
    Shop(4, 'Dollarama', '../assets/home-assets/dollarama-rz.png'),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (Shop s in shops) {
      widgets.add(_getSizedBoxBtn(s, context));
      widgets.add(const SizedBox(height: 30));
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widgets,
      ),
    );
  }
}

class ListPageWidget extends StatefulWidget {
  const ListPageWidget({Key? key, required this.shop}) : super(key: key);

  final Shop shop;

  @override
  State<ListPageWidget> createState() => _ListPageWidgetState();
}

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

// PRIVATE Fn
void _goToListPage(Shop store, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ListPageWidget(shop: store)),
  );
}

GestureDetector _getBtn(Shop store, BuildContext context) {
  return GestureDetector(
    child: Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: null,
        image: DecorationImage(
          image: AssetImage(store.img as String),
          fit: BoxFit.cover,
        ),
      ),
    ),
    onTap: () => _goToListPage(store, context),
  );
}

GestureDetector _getSizedBoxBtn(
  Shop store,
  BuildContext context,
) {
  return GestureDetector(
    child: SizedBox(
      child: Image.asset(
        store.img as String,
        width: 200,
        height: 50,
      ),
    ),
    onTap: () => _goToListPage(store, context),
  );
}
