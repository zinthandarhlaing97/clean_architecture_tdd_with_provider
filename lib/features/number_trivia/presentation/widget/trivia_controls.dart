import 'package:clean_architecture_tdd_with_provider/features/number_trivia/presentation/provider/number_trivia_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({Key? key}) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputStr = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          keyboardType: TextInputType.number,
          onChanged: ((value) {
            inputStr = value;
          }),
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: Text("Search"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                onPressed: dispatchConcrete,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                child: Text("Get random trivia"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  primary: Colors.grey.shade400,
                  onPrimary: Colors.black,
                ),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    Provider.of<NumberTriviaProvider>(context, listen: false)
        .getTriviaForConcreteNumberEvent(numberString: inputStr);
  }

  void dispatchRandom() {
    controller.clear();
    Provider.of<NumberTriviaProvider>(context, listen: false)
        .getTriviaForRandomNumberEvent();
  }
}
