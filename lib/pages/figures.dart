import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main_model.dart';

import '../widgets/action_figures.dart';

class FiguresPage extends StatefulWidget {
  final MainModel model;

  FiguresPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _FiguresPageState();
  }
}

class _FiguresPageState extends State<FiguresPage> {
  @override
  initState() {
    widget.model.fetchFigures();
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Add to the catalog!'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/catalogcontribute');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFiguresList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No figures found!'));
        if (model.displayedFigures.length > 0 && !model.isLoading) {
          content = ActionFigures();  
        } else if (model.isLoading) {
          content = Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(onRefresh: model.fetchFigures, child: content,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Comics&Figures'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          ),
        ],
      ),
      //body: FigureManager(startingFigure: 'Cignus Hyoga',),
      body: _buildFiguresList(),
    );
  }
}
