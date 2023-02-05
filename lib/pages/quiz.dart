import 'package:flutter/material.dart';
import 'result.dart';

class quizPage extends StatefulWidget {
  const quizPage({super.key});

  @override
  State<quizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<quizPage> {
  PageController controller = PageController();
  final key = GlobalKey<FormState>();
  TextEditingController answerController = TextEditingController();
  int currentIndex = 0;

  List<String> questions = [
    '255 % 10= ',
    '17 + 13= ',
    '15 * 5 = ',
    '20 - 7 = ',
    '38 + 9 = '
  ];
  List<String> correctAnswerList = ['5', '30', '75', '13', '47'];

  List<String> userAnswerList = [];

  toNextPage() async {
    await controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    setState(() {
      answerController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Quiz'),
        centerTitle: true,
      ),
      body: Form(
        key: key,
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: questions.length,
                itemBuilder: (context, index) => QuizWidget(
                  onTap: () {
                    if (key.currentState!.validate()) {
                      setState(() {
                        userAnswerList.add(answerController.text);
                      });
                      if ((currentIndex + 1) >= questions.length) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultPage(
                              questions: questions,
                              correctAns: correctAnswerList,
                              userAns: userAnswerList,
                            ),
                          ),
                        );
                      }
                      toNextPage();
                    }
                  },
                  controller: answerController,
                  question: questions[index],
                ),
              ),
            ),
            Text(
              '${currentIndex + 1}/${questions.length}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class QuizWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String question;
  final TextEditingController controller;
  const QuizWidget({
    super.key,
    required this.onTap,
    required this.question,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Text(
            '$question ?',
            style: const TextStyle(
              fontSize: 42,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value == '') {
                return 'Please fill the answer';
              }
              return null;
            },
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              hintText: 'Enter your answer',
              hintStyle: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: onTap,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
