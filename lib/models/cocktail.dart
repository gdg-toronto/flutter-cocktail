import 'package:flutter/foundation.dart';

class Cocktail {
  int id;
  String title;
  String category;
  String glass;
  String instructions;
  String imageThumb;
  List<String> ingredients;
  List<String> measures;

  bool favourite;

  Cocktail(
      {@required this.id,
      this.title,
      this.category,
      this.glass,
      this.instructions,
      this.imageThumb,
      this.ingredients,
      this.measures,
      this.favourite = false});

  Cocktail.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['idDrink']),
        title = json['strDrink'],
        category = json['strCategory'],
        glass = json['strGlass'],
        instructions = json['strInstructions'],
        imageThumb = json['strDrinkThumb'],
        ingredients = (List<int>.generate(15, (i) => i + 1))
            .map((i) {
              return json["strIngredient" + i.toString()];
            })
            .toList()
            .cast<String>(),
        measures = (List<int>.generate(15, (i) => i + 1))
            .map((i) {
              return json["strIngredient" + i.toString()];
            })
            .toList()
            .cast<String>(),
        favourite = false;

  void toggleFavourite() => this.favourite = !this.favourite;
}
