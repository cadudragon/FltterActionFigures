import 'package:flutter/material.dart';
import '../models/User.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageContext();
  }
}

class _AuthPageContext extends State<AuthPage> {
  final User _user = new User();
  bool _accpetTerms = false;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage(
        'assets/images/saintseya_bg01.jpg',
      ),
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: "Email", filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      onChanged: (String value) {
        _user.email = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Password", filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.text,
      onChanged: (String value) {
        _user.password = value;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black26,
      ),
      child: SwitchListTile(
        value: _accpetTerms,
        onChanged: (bool value) {
          setState(() {
            _accpetTerms = value;
          });
        },
        title: Text(
          'Accept Terms',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_user.email.trim() == "" || _user.password.trim() == "") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              content: Text('Email or Password empty.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else {
      Navigator.pushReplacementNamed(context, '/figures');
    }
  }

  @override
  Widget build(BuildContext context) {
    final targertWidth = MediaQuery.of(context).size.width > 550.0 ? 500.0 : MediaQuery.of(context).size.width * 0.95; 
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      //body: FigureManager(startingFigure: 'Cignus Hyoga',),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container( 
              width: targertWidth,
              child:  Column(
              children: <Widget>[
                _buildEmailTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _buildPasswordTextField(),
                _buildAcceptSwitch(),
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                  child: Text('Login'),
                  textColor: Colors.white,
                  onPressed: _submitForm,
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}
