import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPrefrences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSourceImpl;
  late MockSharedPrefrences mockSharedPrefrences;

  setUp(() {
    mockSharedPrefrences = MockSharedPrefrences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPrefrences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(fixture('trivia_cached.json')),
    );
    test('should return number trivia from shared', () async {
      // arrange
      when(
        () => mockSharedPrefrences.getString(any()),
      ).thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await dataSourceImpl.getLastNumberTrivia();

      //assert
      verify(() => mockSharedPrefrences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw cached exception when there is not a value', () {
      // arrange
      when(() => mockSharedPrefrences.getString(any())).thenReturn(null);

      final call = dataSourceImpl.getLastNumberTrivia;

      //act & assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      // verify(() => mockSharedPrefrences.getString(CACHED_NUMBER_TRIVIA));
    });
  });

  group('cachedNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: 1,
    );

    test('should call sharedPreferance to cache the data', () async {
      // arrange
      final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
      when(
        () => mockSharedPrefrences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      // act
      await dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);

      //assert
      verify(() => mockSharedPrefrences.setString(any(), expectedJsonString));
    });
  });
}
