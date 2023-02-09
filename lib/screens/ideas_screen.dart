import 'package:flutter/material.dart';
import 'package:giftsbyai/constants/styles.dart';
import 'package:giftsbyai/models/openai_model.dart';

class IdeasScreen extends StatelessWidget {
  GptData gptReponseData;
  IdeasScreen({super.key, required this.gptReponseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "the AI has spoken 🥳",
            style: kTitleText,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            gptReponseData.choices[0].text,
            style: kSubTitleText,
          ),
        )
      ]),
    );
  }
}
