import 'package:clean_architecture_tdd/core/network/network_info.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(
      dataConnectionChecker: mockDataConnectionChecker,
    );
  });



    group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      () async {
        // arrange
        final tHasConnection = Future.value(true);
        when(
          () => mockDataConnectionChecker.hasConnection,
        ).thenAnswer((_)  => tHasConnection);

        // act
        final result = networkInfoImpl.isConnected;

        //assert
        verify(() => mockDataConnectionChecker.hasConnection);
        expect(result, equals(tHasConnection));
      },
    );
  });
}
