import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/domain/repositires/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
  
}