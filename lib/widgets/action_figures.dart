import 'package:flutter/material.dart';

import 'figure_card.dart';

class ActionFigures extends StatelessWidget {
  final List<Map<String, dynamic>> figures;

  ActionFigures(this.figures) {
    print('ActionFigures Constructor');
  }

 

  Widget _buildFigureList() {
    Widget figureWidget = Center(
      child: Text('No Figures, add some!'),
    );

    if (figures.length > 0) {
      figureWidget = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>FigureCard(figures[index], index),
        itemCount: figures.length,
      );
    }
    return figureWidget;
  }

  @override
  Widget build(BuildContext context) {
    print('ActionFigures build');
    return _buildFigureList();
  }
}
