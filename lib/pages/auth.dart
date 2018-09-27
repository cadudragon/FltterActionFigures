import 'package:flutter/material.dart';
import '../models/User.dart';
import '../util/util_validations.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageContext();
  }
}

class _AuthPageContext extends State<AuthPage> {
  final User _user = new User();
  bool _accpetTerms = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: Colors.white,
      ),
      initialValue: 'carlos8eduardo@gmail.com',
      validator: (String value) {
        if (value.isEmpty || !UtilValidations.isEmail(value)) {
          return 'Email is required and should be an valid email.';
        }
      },
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        _user.email = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      initialValue: '1234567',
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password is required and should be 6+ characters long.';
        }
      },
      decoration: InputDecoration(
          labelText: "Password", filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
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
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    Navigator.pushReplacementNamed(context, '/figures');
  }

  @override
  Widget build(BuildContext context) {
    final targertWidth = MediaQuery.of(context).size.width > 550.0
        ? 500.0
        : MediaQuery.of(context).size.width * 0.95;
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
              child: Form(
                key: _formKey,
                child: Column(
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
      ),
    );
  }
}
