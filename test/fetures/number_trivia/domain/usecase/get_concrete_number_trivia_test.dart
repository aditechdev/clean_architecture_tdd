import 'package:clean_architecture_tdd/fetures/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/domain/repositires/number_trivia_repository.dart';
import 'package:clean_architecture_tdd/fetures/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;

  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);

  test('should get trivia for the given number', () async {
    // arrange
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
        .thenAnswer((_) async => Right(tNumberTrivia));
    // act
    final result = await usecase(number: tNumber);
    // assert
    expect(result, Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
