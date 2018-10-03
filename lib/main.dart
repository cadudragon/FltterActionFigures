import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:flutter/rendering.dart';

import './scoped-models/main_model.dart';


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
    // TODO: implement build
    return ScopedModel<MainModel>(
      model: MainModel(),
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
          '/figures': (BuildContext context) => FiguresPage(),
          '/catalogcontribute': (BuildContext context) => CatalogueContribute(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'figure') {
            final int index = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  FigurePage(index),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => FiguresPage());
        },
      ),
    );
  }
}
