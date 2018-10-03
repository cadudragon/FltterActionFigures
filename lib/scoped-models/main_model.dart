import 'package:scoped_model/scoped_model.dart';

import './connected_figure_model.dart';

class MainModel extends Model with UserModel, FigureModel,ConnectedFigureModel {}
