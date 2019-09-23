import 'package:flutter/material.dart';
import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:flutter_cocktail/providers/cocktails_model.dart';
import 'package:flutter_cocktail/pages/details.dart';
import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';

class CocktailListItem extends StatelessWidget {
  final Cocktail cocktail;

  CocktailListItem({@required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Provider.of<CocktailModel>(context)
            .fetchAndUpdateCocktailDetails(cocktail.id);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CocktailDetails(cocktail: cocktail),
          ),
        );
      },
      leading: Padding(
        child: CachedNetworkImage(
            height: 60, width: 60, imageUrl: cocktail.imageThumb),
        padding: EdgeInsets.all(5),
      ),
      title: Text(cocktail.title),
      trailing: IconButton(
        icon: Icon(
          cocktail.favourite ? Icons.star : Icons.star_border,
          color: Colors.amberAccent,
        ),
        onPressed: () {
          Provider.of<CocktailModel>(context, listen: false)
              .toggleFavourite(cocktail);
        },
      ),
    );
  }
}
