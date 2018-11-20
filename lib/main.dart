import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';
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
  MapView.setApiKey('AIzaSyD8Cfxtvd3v0B5Fqep2Zhkl3Yd3uvtjThU');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build method main.dart');
    // TODO: implement build
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        //debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepPurple),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) =>
              _isAuthenticated ? FiguresPage(_model) : AuthPage(),
          '/catalogcontribute': (BuildContext context) =>
             _isAuthenticated ?  CatalogueContribute(_model) : AuthPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          if(!_isAuthenticated){
            return  MaterialPageRoute<bool>(
              builder: (BuildContext context) =>  AuthPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'figure') {
            final String figureId = pathElements[2];
            final Figure figure = _model.allFigures.firstWhere((Figure figure) {
              return figure.id == figureId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>  _isAuthenticated ? FigurePage(figure): AuthPage(),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>  _isAuthenticated ? FiguresPage(_model): AuthPage());
        },
      ),
    );
  }
}
