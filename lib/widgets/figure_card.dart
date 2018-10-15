import 'package:flutter/material.dart';

import './price_tag.dart';
import './adress_tag.dart';
import './ui_widgets/title_default.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/Figure.dart';
import '../scoped-models/main_model.dart';

class FigureCard extends StatelessWidget {
  final Figure figure;
  final int figureIndex;

  FigureCard(this.figure, this.figureIndex);

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/figure/' + model.allFigures[figureIndex].id),
              ),
              IconButton(
                icon: Icon(model.allFigures[figureIndex].isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  model.selectFigure(model.allFigures[figureIndex].id);
                  model.toggleFigureFavoriteStatus();
                },
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(figure.image),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/images/saintseya_bg01.jpg'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TitleDefault(figure.title),
              SizedBox(
                width: 8.0,
              ),
              PriceTag(figure.price.toString()),
            ],
          ),
          AdressTag('Guarujá São Paulo'),
          AdressTag(figure.userEmail),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
