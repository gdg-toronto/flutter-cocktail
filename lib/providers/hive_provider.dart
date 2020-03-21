import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:flutter_cocktail/providers/cache_provider.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveProvider implements CacheProvider {
  Box<Cocktail> _box;

  @override
  open() async {
    await Hive.initFlutter();
    Hive.registerAdapter<Cocktail>(CocktailAdapter());
    Hive.registerAdapter<Ingredient>(IngredientAdapter());
    _box = await Hive.openBox<Cocktail>('cocktailDb');
  }

  @override
  Future<bool> doesCacheExist() {
    return Future.value(_box.values.length > 0);
  }

  @override
  Future<List<Cocktail>> getCocktails() {
    List<Cocktail> cocktails = _box.values.toList();
    cocktails.sort((e1, e2) => e1.title.compareTo(e2.title));
    return Future.value(cocktails);
  }

  @override
  Future<List<Ingredient>> getIngredients(int cocktailId) async {
    Cocktail cocktail = await _getCocktail(cocktailId);
    return cocktail.ingredients;
  }

  @override
  updateCocktail(Cocktail cocktail) {
    cocktail.save();
  }

  @override
  writeCocktailList(List<Cocktail> cocktails) {
    _box.putAll(Map.fromIterable(cocktails, key: (e) => e.id, value: (e) => e));
  }

  Future<Cocktail> _getCocktail(int cocktailId) async {
    return _box.get(cocktailId);
  }
}
