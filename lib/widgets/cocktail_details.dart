import 'package:flutter/material.dart';
import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:flutter_cocktail/providers/cocktails_model.dart';
import 'package:provider/provider.dart';

class CocktailDetails extends StatelessWidget {
  final Cocktail cocktail;

  CocktailDetails({Key key, @required this.cocktail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(children: <Widget>[
          Image.network(cocktail.imageThumb),
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
          backArrow(context)
        ]));
  }

  static Widget backArrow(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
            padding: EdgeInsets.all(18.0),
            margin: EdgeInsets.only(top: 48.0),
            child: Icon(Icons.arrow_back, color: Colors.white)));
  }

  List<Widget> _buildDetailsWidgets(CocktailModel cocktailModel, int id) {
    var cocktail = cocktailModel.getCocktailById(id);

    // TODO: Refactor this

    var detailsList = <Widget>[
      Align(
          alignment: Alignment.topCenter,
          child: Text(cocktail.title, style: TextStyle(fontSize: 20)))
    ];
    if (!cocktail.detailsLoaded) {
      detailsList.addAll([
        Divider(height: 60, color: Colors.transparent),
        Center(child: CircularProgressIndicator())
      ]);
    } else {
      detailsList.addAll([
        Divider(height: 20, color: Colors.transparent),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
              "${cocktailModel.getCocktailById(cocktail.id).instructions}"),
        ),
        Divider(height: 20, color: Colors.transparent)
      ]);

      for (int i = 0; i < cocktail.ingredients.length; i++) {
        if (cocktail.ingredients[i] == null || cocktail.ingredients[i].isEmpty)
          continue;

        detailsList.add(Card(
            color: Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("${cocktail.measures[i]} ${cocktail.ingredients[i]}",
                  style: TextStyle(color: Colors.black)),
            )));
      }
    }

    detailsList.add(Divider(height: 60, color: Colors.transparent));

    return detailsList;
  }
}
