import 'dart:convert';

import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:flutter_cocktail/providers/cache_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsProvider implements CacheProvider {
  SharedPreferences _sharedPreferences;

  @override
  Future<bool> doesCacheExist() async {
    return _sharedPreferences.getString("cocktails") != null;
  }

  @override
  Future<List<Cocktail>> getCocktails() async {
    return (jsonDecode(_sharedPreferences.getString("cocktails") ?? "[]")
            as List)
        .map((e) => Cocktail.fromMap(e))
        .toList();
  }

  @override
  Future<List<Ingredient>> getIngredients(int cocktailId) async {
    Cocktail cocktail = _getCocktail(cocktailId);
    return cocktail.ingredients;
  }

  @override
  Future open() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  updateCocktail(Cocktail cocktail) async {
    List<Cocktail> cocktails = await getCocktails();
    int index = cocktails.indexWhere((e) => e.id == cocktail.id);
    cocktails[index] = cocktail;
    writeCocktailList(cocktails);
  }

  @override
  writeCocktailList(List<Cocktail> cocktails) async {
    await _sharedPreferences.setString("cocktails", jsonEncode(cocktails));
  }

  Cocktail _getCocktail(int cocktailId) {
    return (jsonDecode(_sharedPreferences.getString("cocktails") ?? "[]")
            as List)
        .map((e) => Cocktail.fromMap(e))
        .firstWhere((e) => e.id == cocktailId);
  }
}
