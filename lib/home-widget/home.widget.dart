import 'package:flutter/material.dart';
import 'package:kshoplist/list-page-widget/list_page.widget.dart';
import 'package:kshoplist/models/store.dart';
import 'dart:io';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  /* Todo:
   - this should come from api
   - store images in dropbox
   - add '+' and '-' btn to be able to add/remove stores
  */
  List<Shop> shops = [
    Shop(1, 'Costco', 'assets/images/costco-rz.png'),
    Shop(2, 'Safeway', 'assets/images/safeway-rz.png'),
    Shop(3, 'Superstore', 'assets/images/superstore-rz.png'),
    Shop(4, 'Dollarama', 'assets/images/dollarama-rz.png'),
  ];

  @override
  Widget build(BuildContext context) {
    // to check app conectivity
    // hasNetwork();
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

/* PRIVATE
---------------------------------------------------------------------*/
GestureDetector _getSizedBoxBtn(
  Shop store,
  BuildContext context,
) {
  return GestureDetector(
    child: SizedBox(
      child: Image.asset(store.img as String),
    ),
    onTap: () => _goToListPage(store, context),
  );
}

void _goToListPage(Shop store, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ListPageWidget(shop: store)),
  );
}

void hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      debugPrint("Internet: connected");
    }
  } on SocketException catch (_) {
    debugPrint("Internet: NOT connected");
  }
}
