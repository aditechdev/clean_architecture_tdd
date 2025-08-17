import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/network/network_info.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreterNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      text: "Test Trivia",
      number: tNumber,
    );

    // final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Act
      await repository.getConcreteNumberTrivia(tNumber);

      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Add this missing mock for all online tests
        when(
          () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
        ).thenAnswer((_) async {});
      });

      test(
        'should return data when the call to remote data source is successful',
        () async {
          // arrange
          // when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
          ).thenAnswer((_) async => Right(tNumberTriviaModel));

          // when(
          //   () => mockLocalDataSource.cacheNumberTrivia(any()),
          // ).thenAnswer((_) async => Future.value());

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          // verify(() => mockNetworkInfo.isConnected);
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, Right(tNumberTriviaModel));
        },
      );

      test(
        'should cached data the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
          ).thenAnswer((_) async => Right(tNumberTriviaModel));
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          );
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
          ).thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, Left(ServerFailure()));
        },
      );
    });
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('Should return lastly cached data is present', () async {
        // arrange

        when(
          () => mockLocalDataSource.getLastNumberTrivia(),
        ).thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTriviaModel));
      });

      test('Should return cache failure when no data is present', () async {
        // arrange

        when(
          () => mockLocalDataSource.getLastNumberTrivia(),
        ).thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailuere()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: "Test Trivia",
      number: 123,
    );

    // final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Act
      await repository.getRandomNumberTrivia();

      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Add this missing mock for all online tests
        when(
          () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
        ).thenAnswer((_) async {});
      });

      test(
        'should return data when the call to remote data source is successful',
        () async {
          // arrange
          // when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          ).thenAnswer((_) async => Right(tNumberTriviaModel));

          // when(
          //   () => mockLocalDataSource.cacheNumberTrivia(any()),
          // ).thenAnswer((_) async => Future.value());

          // act
          final result = await repository.getRandomNumberTrivia();
          //assert
          // verify(() => mockNetworkInfo.isConnected);
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, Right(tNumberTriviaModel));
        },
      );

      test(
        'should cached data the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          ).thenAnswer((_) async => Right(tNumberTriviaModel));
          // act
          await repository.getRandomNumberTrivia();
          //assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verify(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          );
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
          ).thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, Left(ServerFailure()));
        },
      );
    });
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('Should return lastly cached data is present', () async {
        // arrange

        when(
          () => mockLocalDataSource.getLastNumberTrivia(),
        ).thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTriviaModel));
      });

      test('Should return cache failure when no data is present', () async {
        // arrange

        when(
          () => mockLocalDataSource.getLastNumberTrivia(),
        ).thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailuere()));
      });
    });
  });
}
