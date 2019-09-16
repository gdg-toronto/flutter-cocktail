import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class CocktailModel extends ChangeNotifier {
  CocktailModel() {
    fetchCocktailList();
  }

  List<Cocktail> _cocktails = [];

  UnmodifiableListView<Cocktail> get allCocktails =>
      UnmodifiableListView(_cocktails);

  UnmodifiableListView<Cocktail> get favouriteCocktails =>
      UnmodifiableListView(_cocktails.where((cocktail) => cocktail.favourite));

  void toggleFavourite(Cocktail cocktail) {
    cocktail.toggleFavourite();
    notifyListeners();
  }

  Future<void> fetchCocktailList() async {
    _cocktails = await http
        .get(Constant.COCKTAIL_LIST_URL)
        .then((r) => getFromJson(r.body));
    print("size = ${_cocktails.length}");
    notifyListeners();
  }

  List<Cocktail> getFromJson(String json) {
    return (jsonDecode(json)['drinks'] as List)
        .map((e) => Cocktail.fromJson(e))
        .toList();
  }
}
