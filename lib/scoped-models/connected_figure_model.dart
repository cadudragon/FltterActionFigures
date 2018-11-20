import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import '../models/Figure.dart';
import '../models/User.dart';
import '../models/auth_mode.dart';

class ConnectedFigureModel extends Model {
  List<Figure> _figures = [];
  String _selFigureId;
  User _authenticatedUser;
  bool _isLoading = false;
}

class FigureModel extends ConnectedFigureModel {
  bool _showFavorites = false;

  List<Figure> get allFigures {
    return List.from(_figures);
  }

  List<Figure> get displayedFigures {
    if (_showFavorites) {
      return List.from(
          _figures.where((Figure figure) => figure.isFavorite).toList());
    }
    return List.from(_figures);
  }

  int get selectedFigureIndex {
    return _figures.indexWhere((Figure figure) {
      return figure.id == _selFigureId;
    });
  }

  String get selectedFigureId {
    return _selFigureId;
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void clearSelectedFigure() {
    _selFigureId = null;
  }

  Figure get selectedFigure {
    if (selectedFigureId == null) return null;
    return _figures.firstWhere((Figure figure) {
      return figure.id == _selFigureId;
    });
  }

  Future<bool> addFigure(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> figureData = {
      'title': title,
      'description': description,
      'image':
          'https://i.pinimg.com/originals/39/6d/83/396d830a20eaea826eb746e29fb82cea.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    try {
      final http.Response response = await http.post(
          'https://flutter-figures.firebaseio.com/figures.json?auth=${_authenticatedUser.token}',
          body: json.encode(figureData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Figure figure = Figure(
          id: responseData['name'],
          title: title,
          description: description,
          image:
              'https://i.pinimg.com/originals/39/6d/83/396d830a20eaea826eb746e29fb82cea.jpg',
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _figures.add(figure);
      _selFigureId = null;
      _isLoading = false;
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFigure(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'id': selectedFigure.id,
      'title': title,
      'description': description,
      'image':
          'https://i.pinimg.com/originals/39/6d/83/396d830a20eaea826eb746e29fb82cea.jpg',
      'price': price,
      'userEmail': selectedFigure.userEmail,
      'userId': selectedFigure.userId
    };
    return http
        .put(
            'https://flutter-figures.firebaseio.com/figures/${selectedFigure.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Figure figure = Figure(
          id: selectedFigure.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedFigure.userEmail,
          userId: selectedFigure.userId);

      _figures[selectedFigureIndex] = figure;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteFigure() {
    _isLoading = true;
    final figureId = selectedFigure.id;

    _figures.removeAt(selectedFigureIndex);
    _selFigureId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-figures.firebaseio.com/figures/${figureId}.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchFigures({onlyForUser =  false}) {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://flutter-figures.firebaseio.com/figures.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Figure> fetchedFiguresList = [];
      final Map<String, dynamic> figureListData = json.decode(response.body);

      if (figureListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      figureListData.forEach((String key, dynamic figureData) {
        final Figure figure = Figure(
            id: key,
            title: figureData['title'],
            description: figureData['description'],
            image: figureData['image'],
            price: figureData['price'],
            userEmail: figureData['userEmail'],
            userId: figureData['userId'].toString(),
            isFavorite: figureData['whishlistUsers'] == null
                ? false
                : (figureData['whishlistUsers'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id));

        fetchedFiguresList.add(figure);
      });

      _figures = onlyForUser ? fetchedFiguresList.where((Figure figure){
        return figure.userId == _authenticatedUser.id;
      }).toList() : fetchedFiguresList;
      _isLoading = false;
      notifyListeners();
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void selectFigure(String figureId) {
    _selFigureId = figureId;
    notifyListeners();
  }

  void toggleFigureFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedFigure.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    _figures[selectedFigureIndex] = new Figure(
        id: selectedFigure.id,
        description: selectedFigure.description,
        image: selectedFigure.image,
        price: selectedFigure.price,
        title: selectedFigure.title,
        isFavorite: !selectedFigure.isFavorite,
        userEmail: selectedFigure.userEmail,
        userId: selectedFigure.userId);
    notifyListeners();

    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://flutter-figures.firebaseio.com/figures/${selectedFigure.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: jsonEncode(true));
    } else {
      response = await http.delete(
          'https://flutter-figures.firebaseio.com/figures/${selectedFigure.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }

    if (response.statusCode == 200) return;
    _figures[selectedFigureIndex] = new Figure(
        id: selectedFigure.id,
        description: selectedFigure.description,
        image: selectedFigure.image,
        price: selectedFigure.price,
        title: selectedFigure.title,
        isFavorite: !newFavoriteStatus,
        userEmail: selectedFigure.userEmail,
        userId: selectedFigure.userId);
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedFigureModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode authMode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
        authMode == AuthMode.Login
            ? 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyCY6C87hNfWcZaDyssVgbwFw54zbr02ado'
            : 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCY6C87hNfWcZaDyssVgbwFw54zbr02ado',
        body: jsonEncode(authData),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = responseData.containsKey('idToken') ? false : true;
    String message = 'Authentication succeeded';
    if (hasError) {
      switch (responseData['error']['message']) {
        case 'EMAIL_NOT_FOUND':
          message = 'This email was not found';
          break;
        case 'INVALID_PASSWORD':
          message = 'Invalid password';
          break;
        case 'USER_DISABLED':
          message = 'This account is disabled';
          break;
        case 'EMAIL_EXISTS':
          message = 'This email already exists.';
          break;
        default:
          message = 'Something went wrong';
          break;
      }
    } else {
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      setAuthTimeout(int.parse(responseData['expiresIn']));
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _userSubject.add(true);
      sharedPreferences.setString('token', responseData['idToken']);
      sharedPreferences.setString('userEmail', email);
      sharedPreferences.setString('userId', responseData['localId']);
      sharedPreferences.setString('expiryTime', expiryTime.toIso8601String());
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    if (sharedPreferences.getString('token') == null) return;

    final DateTime expiryTime =
        DateTime.parse(sharedPreferences.getString('expiryTime'));

    if (expiryTime.isBefore(DateTime.now())) {
      _authenticatedUser = null;
      notifyListeners();
      return;
    }

    final int tokenLifespan = expiryTime.difference(DateTime.now()).inSeconds;
    setAuthTimeout(tokenLifespan);
    _authenticatedUser = User(
        email: sharedPreferences.getString('userEmail'),
        token: sharedPreferences.getString('token'),
        id: sharedPreferences.getString('userId'));

    _userSubject.add(true);
    notifyListeners();
  }

  void logout() async {
    print('logout');
    _authTimer.cancel();
    _authenticatedUser = null;
    _userSubject.add(false);
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.remove('token');
    sharedPreferences.remove('userEmail');
    sharedPreferences.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

class UtilityModel extends ConnectedFigureModel {
  bool get isLoading {
    return _isLoading;
  }
}
