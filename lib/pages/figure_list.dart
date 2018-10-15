import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './figure_edit_page.dart';
import '../scoped-models/main_model.dart';

class FigureListPage extends StatefulWidget {
  final MainModel model;
  FigureListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _FigureListPageState();
  }
}

class _FigureListPageState extends State<FigureListPage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchFigures(); 
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectFigure(model.allFigures[index].id);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return FigureEditPage();
            },
          ),
        ).then((_) {
          model.selectFigure(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.allFigures[index].title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectFigure(model.allFigures[index].id);
                  model.deleteFigure();
                }
              },
              background: Container(
                color: Colors.red,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        model.allFigures[index].image,
                      ),
                    ),
                    title: Text(model.allFigures[index].title),
                    subtitle:
                        Text('\$${model.allFigures[index].price.toString()}'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: model.allFigures.length,
        );
      },
    );
  }
}
