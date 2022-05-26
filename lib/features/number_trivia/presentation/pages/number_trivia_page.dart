import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../injection_container.dart';
import '../provider/number_trivia_controller.dart';
import '../provider/number_trivia_state.dart';
import '../widget/widget.dart';

class NumberTriviaHomePage extends StatelessWidget {
  const NumberTriviaHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<NumberTriviaProvider>()),
      ],
      child: NumberTriviaPage(),
    );
  }
}

class NumberTriviaPage extends StatefulWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  State<NumberTriviaPage> createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia with Provider'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const SizedBox(height: 10),
        Consumer<NumberTriviaProvider>(
          builder: (context, provider, child) {
            if (provider.state is Empty) {
              return MessageDisplay(message: 'Start searching!');
            } else if (provider.state is Loading) {
              return LoadingWidget();
            } else if (provider.state is Loaded) {
              final state = provider.state as Loaded;
              return TriviaDisplay(numberTrivia: state.trivia);
            } else if (provider.state is Error) {
              final state = provider.state as Error;
              return MessageDisplay(message: state.message);
            } else {
              return MessageDisplay(message: 'Someting went wrong');
            }
          },
        ),
        const SizedBox(height: 20),
        TriviaControls(),
      ],
    );
  }
}
