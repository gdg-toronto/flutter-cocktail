// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cocktail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CocktailAdapter extends TypeAdapter<Cocktail> {
  @override
  final typeId = 0;

  @override
  Cocktail read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cocktail(
      id: fields[0] as int,
      title: fields[1] as String,
      category: fields[2] as String,
      glass: fields[3] as String,
      instructions: fields[4] as String,
      imageThumb: fields[5] as String,
      ingredients: (fields[6] as List)?.cast<Ingredient>(),
      favourite: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Cocktail obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.glass)
      ..writeByte(4)
      ..write(obj.instructions)
      ..writeByte(5)
      ..write(obj.imageThumb)
      ..writeByte(6)
      ..write(obj.ingredients)
      ..writeByte(7)
      ..write(obj.favourite);
  }
}

class IngredientAdapter extends TypeAdapter<Ingredient> {
  @override
  final typeId = 1;

  @override
  Ingredient read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ingredient(
      id: fields[0] as int,
      cocktailId: fields[1] as int,
      name: fields[2] as String,
      measurement: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ingredient obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cocktailId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.measurement);
  }
}
