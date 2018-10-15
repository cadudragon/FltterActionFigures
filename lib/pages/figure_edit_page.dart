import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../util/util_validations.dart';

import '../scoped-models/main_model.dart';
import '../models/Figure.dart';

class FigureEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FigureEditPageState();
  }
}

class FigureEditPageState extends State<FigureEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    ' ': 'assets/images/hyoga_v1.jpg'
  };

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Widget _buildTitleTextField(Figure figure) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Figure Title"),
      initialValue: figure == null ? '' : figure.title,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget buildDescripttionTextField(Figure figure) {
    return TextFormField(
        maxLines: 4,
        initialValue: figure == null ? '' : figure.description,
        decoration: InputDecoration(labelText: "Enter the figure Description"),
        validator: (String value) {
          if (value.isEmpty || value.length < 10) {
            return 'Description is required and should be 10+ characters long';
          }
        },
        keyboardType: TextInputType.text,
        onSaved: (String value) {
          _formData['description'] = value;
        });
  }

  Widget _buildPriceTextField(Figure figure) {
    return TextFormField(
        decoration: InputDecoration(labelText: "Enter the price"),
        initialValue: figure == null ? '' : figure.price.toString(),
        validator: (String value) {
          if (value.isEmpty || !UtilValidations.isDecimal(value)) {
            return 'Price is required and should be a number.';
          }
        },
        keyboardType: TextInputType.number,
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        });
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: () => _submitForm(
                    model.addFigure,
                    model.updateFigure,
                    model.selectFigure,
                    model.selectedFigureIndex),
              );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Figure figure) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 550.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: targetPadding,
            ),
            children: <Widget>[
              _buildTitleTextField(figure),
              Text(_formData['title'] == null ? '' : _formData['title']),
              buildDescripttionTextField(figure),
              _buildPriceTextField(figure),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton()
              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('Mu Button'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(
      Function addFigure, Function updateFigure, Function setSelectedProduct,
      [int selectedFigureIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    if (selectedFigureIndex == -1) {
      addFigure(_formData['title'], _formData['description'],
              _formData['image'], _formData['price'])
          .then((bool succedRequest) {
        if (succedRequest) {
          Navigator.pushReplacementNamed(context, '/figures')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text('Please try Again'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                );
              });
        }
      });
    } else {
      updateFigure(_formData['title'], _formData['description'],
              _formData['image'], _formData['price'])
          .then((_) => Navigator.pushReplacementNamed(context, '/figures')
              .then((_) => setSelectedProduct(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      rebuildOnChange: false,
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedFigure);
        return model.selectedFigureIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                    title: Text('Edit Figure'),
                    leading: new IconButton(
                        icon: new Icon(Icons.arrow_back),
                        onPressed: () {
                          model.clearSelectedFigure();
                          Navigator.pop(context, true);
                        })),
                body: pageContent,
              );
      },
    );
  }
}
