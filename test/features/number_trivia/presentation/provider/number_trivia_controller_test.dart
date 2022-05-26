import 'package:clean_architecture_tdd_with_provider/core/util/input_converter.dart';
import 'package:clean_architecture_tdd_with_provider/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_with_provider/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_with_provider/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_with_provider/features/number_trivia/presentation/provider/number_trivia_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_controller_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter,
  NumberTriviaProvider
])
void main() {
  late MockNumberTriviaProvider mockProvider;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    mockProvider = MockNumberTriviaProvider();

    mockProvider.setupProvider();
  });

  test('should call for setup', () {
    mockProvider.setupProvider();
  });

  group('GetTriviaForConcreteNumber', () {
    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act

        // await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // // assert
        // verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );
  });
}
