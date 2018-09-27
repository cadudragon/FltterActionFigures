import 'package:flutter/material.dart';

import './figure_edit_page.dart';

class FigureListPage extends StatelessWidget {
  final Function updateFigure;
  final Function deleteFigure;
  final List<Map<String, dynamic>> figures;
  FigureListPage(this.figures, this.updateFigure, this.deleteFigure);

  Widget _buildEditButton(BuildContext context, int index) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return FigureEditPage(
                figure: figures[index],
                updateFigure: updateFigure,
                figureIndex: index,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(figures[index]['title']),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              deleteFigure(index);
            }
          },
          background: Container(
            color: Colors.red,
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    figures[index]['image'],
                  ),
                ),
                title: Text(figures[index]['title']),
                subtitle: Text('\$${figures[index]['price'].toString()}'),
                trailing: _buildEditButton(context, index),
              ),
              Divider(),
            ],
          ),
        );
      },
      itemCount: figures.length,
    );
  }
}
