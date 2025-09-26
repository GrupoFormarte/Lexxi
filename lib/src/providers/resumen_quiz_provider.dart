import 'package:flutter/material.dart';
import 'package:lexxi/domain/quiz/model/result_quiz_model.dart';

class ResumenQuizProvider with ChangeNotifier {
  ResultQuizModel? _resultQuizModel;

  ResultQuizModel get resultQuizModel => _resultQuizModel!;

  set resultQuizModel(ResultQuizModel resultQuizModel) {
    _resultQuizModel = resultQuizModel;
    notifyListeners();
  }
}
