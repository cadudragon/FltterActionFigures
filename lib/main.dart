import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

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
  List<Map<String, dynamic>> _figures = [];

  void _addFigure(Map<String, dynamic> figure) {
    setState(() {
      _figures.add(figure);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _figures.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      //debugShowMaterialGrid: true,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          buttonColor: Colors.deepPurple 
          ),
      //home: AuthPage(),
      routes: {
        '/': (BuildContext context) =>
            AuthPage(),
        '/figures': (BuildContext context) =>
            FiguresPage(_figures),
        '/catalogcontribute': (BuildContext context) =>
            CatalogueContribute(_addFigure, _deleteProduct),
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
                FigurePage(_figures[index]['title'], _figures[index]['image'],_figures[index]['price'],_figures[index]['description']),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => FiguresPage(_figures));
      },
    );
  }
}
