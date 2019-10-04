import 'dart:convert';

import 'package:flutter/foundation.dart';

final String columnId = '_id';

final String cocktailTitle = 'title';
final String cocktailCategory = 'category';
final String cocktailGlass = 'glass';
final String cocktailInstructions = 'instructions';
final String cocktailImageThumb = 'image_thumb';
final String cocktailFavourite = 'favourite';

final String cocktailColumnId = 'cocktail_id';
final String ingredientName = 'name';
final String ingredientMeasurement = 'measurement';


class Cocktail {
  int id;
  String title;
  String category;
  String glass;
  String instructions;
  String imageThumb;
  List<Ingredient> ingredients;

  bool favourite;

  Cocktail(
      {@required this.id,
      this.title,
      this.category,
      this.glass,
      this.instructions,
      this.imageThumb,
      this.ingredients,
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
              return Ingredient(
                  id: int.parse(json['idDrink'] + i.toString()),
                  cocktailId: int.parse(json['idDrink']),
                  name: json["strIngredient" + i.toString()],
                  measurement: json["strMeasure" + i.toString()]);
            })
            .where((e) => e.name != null)
            .toList()
            .cast<Ingredient>(),
        favourite = false;

  Cocktail.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        title = map[cocktailTitle],
        category = map[cocktailCategory],
        glass = map[cocktailGlass],
        instructions = map[cocktailInstructions],
        imageThumb = map[cocktailImageThumb],
        favourite = map[cocktailFavourite] == 1,
        ingredients = (jsonDecode(map["ingredients"] ?? "[]") as List)
            .map((e) => Ingredient.fromJson(e))
            .toList();

  Map<String, dynamic> toMap() => {
        columnId: id,
        cocktailTitle: title,
        cocktailCategory: category,
        cocktailGlass: glass,
        cocktailInstructions: instructions,
        cocktailImageThumb: imageThumb,
        cocktailFavourite: favourite == true ? 1 : 0
      };

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = toMap();
    // This is slightly hacky because SharedPrefsProvider includes ingredients
    // nested in JSON and DatabaseProvider stores Ingredients as a separate
    // table

    map["ingredients"] =
        jsonEncode(ingredients.map((e) => e.toJson()).toList());
    return map;
  }

  void toggleFavourite() => this.favourite = !this.favourite;

  bool get detailsLoaded => this.instructions != null;

  bool get hasIngredients =>
      this.ingredients != null && this.ingredients.isNotEmpty;

  void updateDetails(Cocktail cachedCocktail) {
    this.instructions = cachedCocktail.instructions;
    this.category = cachedCocktail.category;
    this.glass = cachedCocktail.glass;
    this.ingredients = cachedCocktail.ingredients;
  }
}

class Ingredient {
  int id;
  int cocktailId;
  String name;
  String measurement;

  Ingredient({
    @required this.id,
    this.cocktailId,
    this.name,
    this.measurement,
  });

  Ingredient.fromJson(Map<String, dynamic> map)
      : id = map[columnId],
        cocktailId = map[cocktailColumnId],
        name = map[ingredientName],
        measurement = map[ingredientMeasurement];

  Map<String, dynamic> toJson() => {
        columnId: id,
        cocktailColumnId: cocktailId,
        ingredientName: name,
        ingredientMeasurement: measurement
      };

  String getNameAndMeasurement() {
    if (measurement != null) {
      return "$measurement $name";
    } else {
      return name;
    }
  }
}
