import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_cocktail/pages/home.dart';
import 'package:flutter_cocktail/providers/cocktails_model.dart';

void main() => runApp(CocktailsApp());

class CocktailsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CocktailModel(),
      child: MaterialApp(
        title: 'Cocktail frenzy',
        theme: ThemeData.dark(),
        home: HomeScreen(),
      ),
    );
  }
}
