
# Unit Test projects with pub and Dart with Spec
How were built unit test projects.

## Requisites
- Install
  - [Dart](https://dart.dev/)

## Structure
```text
demo
|--- lib
|--- test
|--- shard.yaml
```

## Configure

## Build project

## Modify project
- Every `test.dart` must be similar to following:
```dart
import 'package:test/test.dart';
import '../lib/example.dart';

void main() {
  group('Example', () {
    final example = Example();

    test('method1', () {
      print('Testing method1...');
      expect(example.method1(X), equals(Expected));
    });

    test('method2', () {
      print('Testing method2...');
      expect(example.method2(X), equals(Expected));
    });
  });
}
```
## Compile and run tests
```bash
dart test
```