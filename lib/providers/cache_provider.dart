import 'package:flutter_cocktail/models/cocktail.dart';

abstract class CacheProvider {
  Future open();

  Future<List<Ingredient>> getIngredients(int cocktailId);

  updateCocktail(Cocktail cocktail);

  writeCocktailList(List<Cocktail> cocktails);

  Future<List<Cocktail>> getCocktails();

  Future<bool> doesCacheExist();
}
