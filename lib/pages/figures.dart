import 'package:flutter/material.dart';
import '../widgets/action_figures.dart';

class FiguresPage extends StatelessWidget {
  final List<Map<String, dynamic>> figures;

  FiguresPage(this.figures);

Widget _buildSideDrawer(BuildContext context){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Comics&Figures'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          )
        ],
      ),
      //body: FigureManager(startingFigure: 'Cignus Hyoga',),
      body: ActionFigures(figures),
    );
  }
}
