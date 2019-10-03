import 'package:flutter/foundation.dart';
import 'package:flutter_cocktail/providers/database_provider.dart';

class Cocktail {
  int id;
  String title;
  String category;
  String glass;
  String instructions;
  String imageThumb;
  List<Ingredient> ingredients;

  bool favourite;
  bool detailsLoaded;

  Cocktail(
      {@required this.id,
      this.title,
      this.category,
      this.glass,
      this.instructions,
      this.imageThumb,
      this.ingredients,
      this.favourite = false,
      this.detailsLoaded = false});

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
            .toList()
            .cast<Ingredient>(),
        favourite = false,
        detailsLoaded = json['strInstructions'] != null;

  Cocktail.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        title = map[cocktailTitle],
        category = map[cocktailCategory],
        glass = map[cocktailGlass],
        instructions = map[cocktailInstructions],
        imageThumb = map[cocktailImageThumb],
        favourite = map[cocktailFavourite] == 1,
        detailsLoaded = map[cocktailInstructions] != null;

  Map<String, dynamic> toMap() => {
        columnId: id,
        cocktailTitle: title,
        cocktailCategory: category,
        cocktailGlass: glass,
        cocktailInstructions: instructions,
        cocktailImageThumb: imageThumb,
        cocktailFavourite: favourite == true ? 1 : 0
      };

  void toggleFavourite() => this.favourite = !this.favourite;

  bool get hasIngredients => this.ingredients != null;

  void updateDetails(Cocktail cachedCocktail) {
    this.instructions = cachedCocktail.instructions;
    this.category = cachedCocktail.category;
    this.glass = cachedCocktail.glass;
    this.ingredients = cachedCocktail.ingredients;
    this.detailsLoaded = cachedCocktail.instructions != null;
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

  Ingredient.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        cocktailId = map[cocktailColumnId],
        name = map[ingredientName],
        measurement = map[ingredientMeasurement];

  Map<String, dynamic> toMap() => {
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
