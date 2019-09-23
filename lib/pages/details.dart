import 'package:flutter/material.dart';
import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:flutter_cocktail/providers/cocktails_model.dart';
import 'package:flutter_cocktail/widgets/back_arrow.dart';
import 'package:flutter_cocktail/widgets/details.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class CocktailDetails extends StatelessWidget {
  final Cocktail cocktail;

  CocktailDetails({Key key, @required this.cocktail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(children: <Widget>[
          CachedNetworkImage(imageUrl: cocktail.imageThumb),
          SingleChildScrollView(
            child: Card(
                elevation: 0,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                margin: EdgeInsets.only(top: 300),
                child: Padding(
                    padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                    child: Consumer<CocktailModel>(
                        builder: (context, cocktailModel, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _buildDetailsWidgets(
                                cocktailModel, cocktail.id))))),
          ),
          BackArrow()
        ]));
  }

  List<Widget> _buildDetailsWidgets(CocktailModel cocktailModel, int id) {
    var cocktail = cocktailModel.getCocktailById(id);
    var detailsWidgets = DetailsWidgetHelper(cocktail);

    detailsWidgets.addCocktailTitle();

    if (!cocktail.detailsLoaded) {
      detailsWidgets.addLoading();
    } else {
      detailsWidgets.addInstructions();
      detailsWidgets.addIngredients();
    }

    detailsWidgets.addFooter();

    return detailsWidgets.getWidgetList();
  }
}
