import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_cocktail/constants.dart';
import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:flutter_cocktail/providers/database_provider.dart';
import 'package:http/http.dart' as http;

class CocktailModel extends ChangeNotifier {
  CocktailModel() {
    openDatabase().then((_) async {
      bool cacheExists = await doesCacheExist();
      // TODO: Expire and update cache

      if (cacheExists) {
        _cocktails = await dbProvider.getCocktails();
        notifyListeners();
      } else {
        await fetchCocktailList();
        writeCocktails();
      }
    });
  }

  List<Cocktail> _cocktails = [];
  DatabaseProvider dbProvider = DatabaseProvider();

  UnmodifiableListView<Cocktail> get allCocktails =>
      UnmodifiableListView(_cocktails);

  UnmodifiableListView<Cocktail> get favouriteCocktails =>
      UnmodifiableListView(_cocktails.where((cocktail) => cocktail.favourite));

  Future<void> openDatabase() async {
    await dbProvider.open("cocktail.db");
  }

  Future<bool> doesCacheExist() async {
    return await dbProvider.getCocktailCount() > 0;
  }

  Future<void> writeCocktails() async {
    await dbProvider.writeCocktailList(_cocktails);
  }

  void toggleFavourite(Cocktail cocktail) {
    cocktail.toggleFavourite();
    dbProvider.updateCocktail(cocktail);
    notifyListeners();
  }

  Future<void> fetchCocktailList() async {
    _cocktails = await http
        .get(Constant.COCKTAIL_LIST_URL)
        .then((r) => getFromJson(r.body));
    print("size = ${_cocktails.length}");
    notifyListeners();
  }

  Future<void> fetchAndUpdateCocktailDetails(Cocktail cocktail) async {
    if (!cocktail.detailsLoaded) {
      var url = Constant.COCKTAIL_DETAILS_URL + cocktail.id.toString();
      var cocktails = await http.get(url).then((r) => getFromJson(r.body));

      cocktail.updateDetails(cocktails[0]);

      print("details fetched for [${cocktail.id}]: ${cocktail.title}");

      dbProvider.updateCocktail(cocktail);
    } else if (!cocktail.hasIngredients) {
      cocktail.ingredients = await dbProvider.getIngredients(cocktail.id);
    }

    notifyListeners();
  }

  List<Cocktail> getFromJson(String json) {
    return (jsonDecode(json)['drinks'] as List)
        .map((e) => Cocktail.fromJson(e))
        .toList();
  }

  Cocktail getCocktailById(int id) {
    return _cocktails.firstWhere((e) => e.id == id);
  }
}
