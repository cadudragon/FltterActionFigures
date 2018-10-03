import 'package:scoped_model/scoped_model.dart';
import '../models/Figure.dart';
import '../models/User.dart';

class ConnectedFigureModel extends Model {
  List<Figure> _figures = [];
  int _selFigureIndex;
  User _authenticatedUser;

  void addFigure(String title, String description, String image, double price) {
    final Figure figure = Figure(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);
    _figures.add(figure);
    _selFigureIndex = null;
    notifyListeners();
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
    return _selFigureIndex;
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Figure get selectedFigure {
    if (selectedFigureIndex == null) return null;
    return _figures[selectedFigureIndex];
  }

  void updateFigure(
      String title, String description, String image, double price) {
    final Figure figure = Figure(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedFigure.userEmail,
        userId: selectedFigure.userId);

    _figures[selectedFigureIndex] = figure;
    notifyListeners();
  }

  void deleteFigure() {
    _figures.removeAt(selectedFigureIndex);
    notifyListeners();
  }

  void selectFigure(int index) {
    _selFigureIndex = index;
    notifyListeners();
  }

  void toggleFigureFavoriteStatus() {
    _figures[selectedFigureIndex] = new Figure(
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
