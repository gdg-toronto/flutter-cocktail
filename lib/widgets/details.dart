import 'package:flutter/material.dart';
import 'package:flutter_cocktail/models/cocktail.dart';

class DetailsWidgetHelper {
  final Cocktail cocktail;
  final List<Widget> detailsList = <Widget>[];

  DetailsWidgetHelper(this.cocktail);

  void addCocktailTitle() {
    detailsList.add(Align(
        alignment: Alignment.topCenter,
        child: Text(cocktail.title, style: TextStyle(fontSize: 20))));
  }

  void addLoading() {
    detailsList.addAll([
      Divider(height: 60, color: Colors.transparent),
      Center(child: CircularProgressIndicator())
    ]);
  }

  void addInstructions() {
    detailsList.addAll([
      Divider(height: 20, color: Colors.transparent),
      Padding(
          padding: const EdgeInsets.all(6),
          child: Text("${cocktail.instructions}")),
      Divider(height: 20, color: Colors.transparent)
    ]);
  }

  void addIngredients() {
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

  void addFooter() {
    detailsList.add(Divider(height: 60, color: Colors.transparent));
  }

  List<Widget> getWidgetList() {
    return detailsList;
  }
}
