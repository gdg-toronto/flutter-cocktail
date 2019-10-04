import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:flutter_cocktail/providers/cache_provider.dart';
import 'package:sqflite/sqflite.dart';

final String _tableCocktail = 'cocktail';
final String _tableIngredient = 'ingredient';

class DatabaseProvider implements CacheProvider {
  final List<String> cocktailColumns = [
    columnId,
    cocktailTitle,
    cocktailCategory,
    cocktailGlass,
    cocktailInstructions,
    cocktailImageThumb,
    cocktailFavourite
  ];

  Database _db;

  @override
  open() async {
    _db = await openDatabase("cocktail.db", version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $_tableCocktail (
  $columnId integer primary key autoincrement,
  $cocktailTitle text not null,
  $cocktailCategory text,
  $cocktailGlass text,
  $cocktailInstructions text,
  $cocktailImageThumb text not null,
  $cocktailFavourite integer not null)
''');
      await db.execute('''
create table $_tableIngredient (
  $columnId integer primary key autoincrement,
  $cocktailColumnId integer not null,
  $ingredientName text not null,
  $ingredientMeasurement text)
''');
    });
  }

  Future<Cocktail> insertCocktail(Cocktail cocktail) async {
    cocktail.id = await _db.insert(_tableCocktail, cocktail.toMap());
    return cocktail;
  }

  Future<Ingredient> insertIngredient(Ingredient ingredient) async {
    ingredient.id = await _db.insert(_tableIngredient, ingredient.toJson());
    return ingredient;
  }

  Future<Cocktail> getCocktail(int id) async {
    List<Map> maps = await _db.query(_tableCocktail,
        columns: cocktailColumns, where: '$columnId = ?', whereArgs: [id]);

    if (maps.length > 0) {
      Cocktail cocktail = Cocktail.fromMap(maps.first);
      cocktail.ingredients = await getIngredients(id);

      return cocktail;
    }
    return null;
  }

  @override
  Future<List<Ingredient>> getIngredients(int cocktailId) async {
    List<Map> ingredients = await _db.query(_tableIngredient,
        columns: [
          columnId,
          cocktailColumnId,
          ingredientName,
          ingredientMeasurement
        ],
        where: '$cocktailColumnId = ?',
        whereArgs: [cocktailId]);

    if (ingredients.length > 0) {
      return ingredients.map((e) => Ingredient.fromJson(e)).toList();
    }
    return null;
  }

  @override
  updateCocktail(Cocktail cocktail) async {
    if (cocktail.hasIngredients) {
      cocktail.ingredients.where((e) => e.name != null).forEach((f) async {
        await _db.rawInsert(
            "INSERT OR REPLACE INTO $_tableIngredient (_id, cocktail_id, name, measurement) VALUES (?, ?, ?, ?)",
            [f.id, cocktail.id, f.name, f.measurement]);
      });
    }
    await _db.update(_tableCocktail, cocktail.toMap(),
        where: '$columnId = ?', whereArgs: [cocktail.id]);
  }

  @override
  writeCocktailList(List<Cocktail> cocktails) async {
    Batch batch = _db.batch();
    cocktails.forEach((e) {
      batch.insert(_tableCocktail, e.toMap());
    });

    await batch.commit();
  }

  @override
  Future<List<Cocktail>> getCocktails() async {
    List<Map> maps = await _db.query(_tableCocktail,
        columns: cocktailColumns, groupBy: cocktailTitle);
    return maps.map((e) => Cocktail.fromMap(e)).toList();
  }

  Future<int> _getCocktailCount() async {
    var rq = await _db.rawQuery("SELECT COUNT(*) FROM $_tableCocktail");
    int count = Sqflite.firstIntValue(rq);
    return count;
  }

  @override
  Future<bool> doesCacheExist() async {
    return await _getCocktailCount() > 0;
  }

  Future close() async => _db.close();
}
