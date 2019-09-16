import 'package:flutter/material.dart';
import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:flutter_cocktail/widgets/cocktail_list_item.dart';

class CocktailsList extends StatelessWidget {
  final List<Cocktail> cocktails;

  CocktailsList({@required this.cocktails});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getCocktails(),
    );
  }

  List<Widget> getCocktails() {
    return cocktails
        .map((cocktail) => CocktailListItem(cocktail: cocktail))
        .toList();
  }
}
