import 'package:clean_architecture_tdd_with_provider/features/number_trivia/presentation/provider/number_trivia_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE =
    "Invalid Input - The number must be a positive integer or zero";

class NumberTriviaProvider with ChangeNotifier {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaState _state = Empty();

  NumberTriviaProvider({
    required this.concrete,
    required this.random,
    required this.inputConverter,
  });
  NumberTriviaState get state => _state;

  // void setupProvider({
  //   required GetConcreteNumberTrivia getConcreteNumberTrivia,
  //   required GetRandomNumberTrivia getRandomNumberTrivia,
  //   required InputConverter inputConverter,
  // }) {
  //   concrete = getConcreteNumberTrivia;
  //   random = getRandomNumberTrivia;
  //   inputConverter = inputConverter;
  //   notifyListeners();
  // }

  Future<void> getTriviaForConcreteNumberEvent({
    required String numberString,
  }) async {
    final inputEither = await inputConverter.stringToUnsignedInteger(
      numberString,
    );

    await inputEither.fold(
      (failure) async {
        _state = Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        notifyListeners();
      },
      (integer) async {
        _state = Loading();
        notifyListeners();
        final failureOrTrivia = await concrete(
          Params(number: integer),
        );
        await _eitherLoadedOrErrorState(failureOrTrivia);
      },
    );
  }

  Future<void> getTriviaForRandomNumberEvent() async {
    _state = Loading();
    notifyListeners();
    final failureOrTrivia = await random(NoParams());
    await _eitherLoadedOrErrorState(failureOrTrivia);
  }

  Future<void> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) async {
    await failureOrTrivia.fold(
      (failure) async {
        _state = Error(message: _mapFilureToMessage(failure));
        notifyListeners();
      },
      (trivia) async {
        _state = Loaded(trivia: trivia);
        notifyListeners();
      },
    );
  }

  String _mapFilureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error";
    }
  }
}
