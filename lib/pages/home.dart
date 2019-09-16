import 'package:flutter/material.dart';
import 'package:flutter_cocktail/tabs/cocktails.dart';
import 'package:flutter_cocktail/tabs/favourites.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktails'),
        bottom: TabBar(
          controller: controller,
          tabs: <Widget>[
            Tab(text: 'Cocktails'),
            Tab(text: 'Favourites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          CocktailsTab(),
          FavouritesTab(),
        ],
      ),
    );
  }
}
