import 'package:flutter/material.dart';

import './price_tag.dart';
import './adress_tag.dart';
import './ui_widgets/title_default.dart';

class FigureCard extends StatelessWidget {
  final Map<String, dynamic> figure;
  final int figureIndex;

  FigureCard(this.figure, this.figureIndex);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(figure['image']),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TitleDefault(figure['title']),
              SizedBox(
                width: 8.0,
              ),
              PriceTag(figure['price'].toString()),
            ],
          ),
          AdressTag('Guarujá São Paulo'),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/figure/' + figureIndex.toString()),
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                color: Colors.red,
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
