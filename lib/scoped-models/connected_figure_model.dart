import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../models/Figure.dart';
import '../models/User.dart';

class ConnectedFigureModel extends Model {
  List<Figure> _figures = [];
  String _selFigureId;
  User _authenticatedUser;
  bool _isLoading = false;

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
          'https://flutter-figures.firebaseio.com/figures.json',
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
            'https://flutter-figures.firebaseio.com/figures/${selectedFigure.id}.json',
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
            'https://flutter-figures.firebaseio.com/figures/${figureId}.json')
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

  Future<Null> fetchFigures() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutter-figures.firebaseio.com/figures.json')
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
            userId: figureData['userId']);

        fetchedFiguresList.add(figure);
      });

      _figures = fetchedFiguresList;
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

  void toggleFigureFavoriteStatus() {
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
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedFigureModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: 1, email: email, password: password);
  }
}

class UtilityModel extends ConnectedFigureModel {
  bool get isLoading {
    return _isLoading;
  }
}
