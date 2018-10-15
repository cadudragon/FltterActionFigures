import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:flutter/rendering.dart';

import './scoped-models/main_model.dart';
import './models/Figure.dart';

import './pages/catalogue_contribute.dart';
import './pages/figure.dart';
import './pages/figures.dart';
import './pages/auth.dart';

void main() {
  // debugPaintSizeEnabled = true;
  //debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    // TODO: implement build
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        //debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepPurple),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/figures': (BuildContext context) => FiguresPage(model),
          '/catalogcontribute': (BuildContext context) =>
              CatalogueContribute(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'figure') {
            final String figureId = pathElements[2];
            final Figure figure = model.allFigures.firstWhere((Figure figure) {
              return figure.id == figureId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => FigurePage(figure),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => FiguresPage(model));
        },
      ),
    );
  }
}
