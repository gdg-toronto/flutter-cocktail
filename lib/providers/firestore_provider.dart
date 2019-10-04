import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:flutter_cocktail/providers/cache_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider implements CacheProvider {
  var _fs;
  AuthResult _fa;

  @override
  Future<bool> doesCacheExist() async {
    QuerySnapshot qs = await _getCocktails()
        .getDocuments();
    return qs.documents.length > 0;
  }

  @override
  Future<List<Cocktail>> getCocktails() async {
    QuerySnapshot qs = await _getCocktails()
        .orderBy(cocktailTitle).getDocuments();
    return qs.documents.map((e) => Cocktail.fromMap(e.data)).toList();
  }

  @override
  Future<List<Ingredient>> getIngredients(int cocktailId) async {
    QuerySnapshot qs = await _getIngredients().where(
        cocktailColumnId, isEqualTo: cocktailId).orderBy(columnId).getDocuments();
    return qs.documents.map((e) => Ingredient.fromJson(e.data)).toList();
  }

  @override
  Future open() async {
    _fs = Firestore.instance;
    _fa = await FirebaseAuth.instance.signInAnonymously();
    print("user id:" + _fa.user.uid);
  }

  _getCocktails() {
    return _fs.collection("user").document(_fa.user.uid).collection("cocktails");
  }

  _getIngredients() {
    return _fs.collection("user").document(_fa.user.uid).collection("ingredients");
  }

  @override
  updateCocktail(Cocktail cocktail) async {
    if (cocktail.hasIngredients) {
      var batch = _fs.batch();
      cocktail.ingredients.where((e) => e.name != null).forEach((f) async {
        var ingredientRef = _getIngredients().document();
        batch.setData(ingredientRef, f.toJson());
      });
      await batch.commit();
    }

    QuerySnapshot qs = await _getCocktails().where(
        columnId, isEqualTo: cocktail.id).getDocuments();
    String docRef = qs.documents.first.documentID;
    _getCocktails().document(docRef).updateData(cocktail.toMap());
  }

  @override
  writeCocktailList(List<Cocktail> cocktails) async {
    var batch = _fs.batch();
    cocktails.forEach((e) {
      var cocktailRef = _getCocktails().document();
      batch.setData(cocktailRef, e.toMap());
    });

    await batch.commit();
  }

}