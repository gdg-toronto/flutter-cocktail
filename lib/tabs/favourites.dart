import 'package:flutter/material.dart';
import 'package:flutter_cocktail/providers/cocktails_model.dart';
import 'package:flutter_cocktail/widgets/cocktail_list.dart';
import 'package:provider/provider.dart';

class FavouritesTab extends StatelessWidget {
  @override
  Key get key => PageStorageKey<String>('faves');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<CocktailModel>(
          builder: (context, cocktails, child) =>
              CocktailsList(cocktails: cocktails.favouriteCocktails)),
    );
  }
}
