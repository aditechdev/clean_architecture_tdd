import 'package:clean_architecture_tdd/fetures/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {

  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  /// 
  /// Throws [CachedException] if no cached data is present. 
  Future<NumberTriviaModel> getLastNumberTrivia(int number);

  
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
