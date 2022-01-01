import 'package:flutter/material.dart';
import 'package:kshoplist/home-widget/home.widget.dart';

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
