import 'package:flutter/material.dart';
import './figure_create_page.dart';
import './figure_list.dart';

class CatalogueContribute extends StatelessWidget {
  final Function addFigure;
  final Function deleteFigure;

  CatalogueContribute(this.addFigure, this.deleteFigure);

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
            title: Text('All Figures'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Catalogue contribution'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Figure',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Contributions',
              )
            ],
          ),
        ),
        //body: FigureManager(startingFigure: 'Cignus Hyoga',),
        body: TabBarView(
          children: <Widget>[FigureCreatePage(addFigure), FigureListPage()],
        ),
      ),
    );
  }
}