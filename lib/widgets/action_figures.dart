import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'figure_card.dart';

import '../models/Figure.dart';
import '../scoped-models/main_model.dart';

class ActionFigures extends StatelessWidget {
  Widget _buildFigureList(List<Figure> figures) {
    Widget figureWidget = Center(
      child: Text('No Figures, add some!'),
    );

    if (figures.length > 0) {
      figureWidget = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            FigureCard(figures[index], index),
        itemCount: figures.length,
      );
    }
    return figureWidget;
  }

  @override
  Widget build(BuildContext context) {
    print('ActionFigures build');
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildFigureList(model.displayedFigures);
      },
    );
  }
}
