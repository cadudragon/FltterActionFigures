import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/ui_widgets/title_default.dart';
import '../scoped-models/main_model.dart';
import '../models/Figure.dart';

class FigurePage extends StatelessWidget {
  final int figureIndex;
  FigurePage(this.figureIndex);

  Widget _buildAdressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Guarujá São Paulo',
          style: TextStyle(fontFamily: 'Oswalvd', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Oswalvd', color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      print('Back button presssed');
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Figure figure = model.allFigures[figureIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text(figure.title),
          ),
          //body: FigureManager(startingFigure: 'Cignus Hyoga',),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(figure.image),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TitleDefault(figure.title),
              ),
              _buildAdressPriceRow(figure.price),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  figure.description,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}
