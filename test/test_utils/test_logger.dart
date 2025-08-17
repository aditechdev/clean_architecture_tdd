
class TestLogger {
  static final TestLogger _instance = TestLogger._internal();
  factory TestLogger() => _instance;
  TestLogger._internal();

  final List<String> _testResults = [];
  final List<String> _logs = [];
  final DateTime _startTime = DateTime.now();

  void logTestResult(
    String testName,
    bool passed, {
    String? error,
    String? details,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final status = passed ? 'PASSED' : 'FAILED';
    final result = '[$timestamp] $status: $testName';

    _testResults.add(result);
    if (error != null) {
      _testResults.add('  Error: $error');
    }
    if (details != null) {
      _testResults.add('  Details: $details');
    }
    _testResults.add(''); // Empty line for readability
  }

  void logInfo(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] INFO: $message';
    _logs.add(logEntry);
    print(logEntry); // Print to console
  }

  void logError(String error) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] ERROR: $error';
    _logs.add(logEntry);
    print(logEntry); // Print to console
  }

  void generateReport() {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime);

    final passed = _testResults.where((r) => r.contains('PASSED')).length;
    final failed = _testResults.where((r) => r.contains('FAILED')).length;
    final total = passed + failed;

    print('\n${'=' * 60}');
    print('TEST EXECUTION REPORT');
    print('=' * 60);
    print('Start Time: ${_startTime.toIso8601String()}');
    print('End Time: ${endTime.toIso8601String()}');
    print('Duration: ${duration.inMilliseconds}ms');
    print('Total Tests: $total');
    print('Passed: $passed');
    print('Failed: $failed');
    print(
      'Success Rate: ${total > 0 ? ((passed / total) * 100).toStringAsFixed(1) : 0}%',
    );
    print('=' * 60);

    if (_testResults.isNotEmpty) {
      print('\nDETAILED TEST RESULTS:');
      print('-' * 40);
      for (final result in _testResults) {
        print(result);
      }
    }

    if (_logs.isNotEmpty) {
      print('\nEXECUTION LOGS:');
      print('-' * 40);
      for (final log in _logs) {
        print(log);
      }
    }

    print('=' * 60);
    print('REPORT END');
    print('=' * 60 + '\n');
  }

  void logTestCoverage(double coveragePercentage) {
    final timestamp = DateTime.now().toIso8601String();
    final coverageLog =
        '[$timestamp] COVERAGE: ${coveragePercentage.toStringAsFixed(2)}%';
    _logs.add(coverageLog);
    _testResults.add(coverageLog);
  }
}
