import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/network/network_info.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/domain/repositires/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(
      () => remoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    Future<Either<Failure, NumberTriviaModel>> Function() getConcreateOrRandom,
  ) async {
    bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteTrivia = await getConcreateOrRandom();

        if (remoteTrivia.isRight()) {
          final trivia = remoteTrivia.getOrElse(
            () => throw Exception("Should not happen"),
          );
          await localDataSource.cacheNumberTrivia(trivia);
        }
        return remoteTrivia;
      } on ServerException {
        // return left(ServerFailure());
        return Left(ServerFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailuere());
      } catch (e) {
        return Left(CacheFailuere());
      }
    }
  }
}
