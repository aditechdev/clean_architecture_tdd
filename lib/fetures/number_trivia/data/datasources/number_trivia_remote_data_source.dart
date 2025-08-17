import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number}?json endpoint
  /// 
  /// Throws a [ServerException] for all error coddes.
  Future<Either<Failure, NumberTriviaModel>> getConcreteNumberTrivia(int number);



  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error coddes.
  Future<Either<Failure, NumberTriviaModel>> getRandomNumberTrivia();
}
