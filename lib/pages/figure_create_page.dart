import 'package:flutter/material.dart';

class FigureCreatePage extends StatefulWidget {
  final Function addFigure;

  FigureCreatePage(this.addFigure);
  @override
  State<StatefulWidget> createState() {
    return FigureCreatePageState();
  }
}

class FigureCreatePageState extends State<FigureCreatePage> {
  String titleValue = '';
  double priceValue = 0.0;
  String descriptionValue = '';
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Figure Title"),
      onSaved: (String value) {
        setState(() {
          titleValue = value;
        });
      },
    );
  }

  Widget buildDescripttionTextField() {
    return TextFormField(
        maxLines: 4,
        decoration: InputDecoration(labelText: "Enter the figure Description"),
        keyboardType: TextInputType.text,
        onSaved: (String value) {
          setState(() {
            descriptionValue = value;
          });
        });
  }

  Widget _buildPriceTextField() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Enter the price"),
        keyboardType: TextInputType.number,
        onSaved: (String value) {
          setState(() {
            priceValue = double.parse(value);
          });
        });
  }

  void _submitForm() {
    _formKey.currentState.save();
    final Map<String, dynamic> figure = {
      'title': titleValue,
      'description': descriptionValue,
      'price': priceValue,
      'image': 'assets/images/hyoga_v1.jpg'
    };

    widget.addFigure(figure);
    Navigator.pushReplacementNamed(context, '/figures');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 550.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: targetPadding,
          ),
          children: <Widget>[
            _buildTitleTextField(),
            Text(titleValue),
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
    );
  }
}
