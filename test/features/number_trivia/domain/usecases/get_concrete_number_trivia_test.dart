import 'package:clean_architecture_tdd_with_provider/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_with_provider/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_with_provider/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetConcreteNumberTrivia usecase;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: "test", number: 1);

  test('should get trivia for the number from the repository', () async {
    // "On the fly" implementation of the Repository using the Mockito package.
    // When getNumberTrivia is called with any argument and always answer with
    // the Right side of Either containing a test Number Trivia Object.
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

    // The act phase of the test. Call the not-yet-existence metod.
    final result = await usecase(Params(number: tNumber));

    // Usecase should simply return whatever was returned from the Repository
    expect(result, Right(tNumberTrivia));

    // Verify that the method has been called on the Repository.
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));

    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
