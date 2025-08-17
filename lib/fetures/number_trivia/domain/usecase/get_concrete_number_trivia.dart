import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/domain/repositires/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);


  Future<Either<Failure, NumberTrivia>> call({required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}