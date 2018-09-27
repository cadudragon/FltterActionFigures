import 'package:flutter/material.dart';

import '../util/util_validations.dart';

class FigureEditPage extends StatefulWidget {
  final Function addFigure;
  final Function updateFigure;
  final Map<String, dynamic> figure;
  final int figureIndex;

  FigureEditPage(
      {this.addFigure, this.updateFigure, this.figure, this.figureIndex});
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
    'image': 'assets/images/hyoga_v1.jpg'
  };

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Figure Title"),
      initialValue: widget.figure == null ? '' : widget.figure['title'],
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

  Widget buildDescripttionTextField() {
    return TextFormField(
        maxLines: 4,
        initialValue: widget.figure == null ? '' : widget.figure['description'],
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

  Widget _buildPriceTextField() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Enter the price"),
        initialValue:
            widget.figure == null ? '' : widget.figure['price'].toString(),
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

  Widget _buildPageContent(BuildContext context) {
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
              _buildTitleTextField(),
              Text(_formData['title'] == null ? '' : _formData['title']),
              buildDescripttionTextField(),
              _buildPriceTextField(),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: _submitForm,
              )
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

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    if (widget.figure == null) {
      widget.addFigure(_formData);
    } else {
      widget.updateFigure(widget.figureIndex, _formData);
    }

    Navigator.pushReplacementNamed(context, '/figures');
  }

  @override
  Widget build(BuildContext context) {
    final Widget pageContent = _buildPageContent(context);

    return widget.figure == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Figure'),
            ),
            body: pageContent,
          );
  }
}
