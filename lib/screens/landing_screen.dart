import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:giftsbyai/constants/styles.dart';
import 'package:giftsbyai/screens/ideas_screen.dart';
import 'package:http/http.dart' as http;
import '../constants/open_ai.dart';
import '../models/openai_model.dart';

const List<String> listOfRelations = <String>[
  'Friend',
  'Partner',
  'Spouse',
  'Sibling'
];
const List<String> listOfOccasions = <String>[
  "Valentine's Day",
  'Birthday',
  'Anniversary',
  'Retirement'
];

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();
  String gender = "prefer not to say";
  String firstDropdownValue = listOfRelations.first;
  String secondDropdownValue = listOfOccasions.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "gifts by 🤖",
              style: kTitleText,
            ),
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "who is the gift for?",
              style: kSubTitleText,
            ),
          ),
          Center(
            child: DropdownButton<String>(
              value: firstDropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  firstDropdownValue = value!;
                });
              },
              items:
                  listOfRelations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "what do they identify as?",
              style: kSubTitleText,
            ),
          ),
          RadioListTile(
            title: Text("Male"),
            value: "male",
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text("Female"),
            value: "female",
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text("Prefer not to say"),
            value: "prefer not to say",
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value.toString();
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "what is the occasion?",
              style: kSubTitleText,
            ),
          ),
          Center(
            child: DropdownButton<String>(
              value: secondDropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  secondDropdownValue = value!;
                });
              },
              items:
                  listOfOccasions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "tell us about their hobbies or interests",
              style: kSubTitleText,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText:
                    'Enter a hobby/interest (Example: Playing Football, Gardening, etc)',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some hobbies';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                var url = Uri.parse('https://api.openai.com/v1/completions');

                Map<String, String> headers = {
                  'Content-Type': 'application/json;charset=UTF-8',
                  'Charset': 'utf-8',
                  'Authorization': 'Bearer $apiKey'
                };

                String promptData =
                    "Suggest gift ideas for someone who is realted to me as $firstDropdownValue of $gender gender for the occasion of $secondDropdownValue in budget less than 10,000 rupees with ${_controller.value.text} as hobbies.";

                print(promptData);
                final data = jsonEncode({
                  "model": "text-davinci-003",
                  "prompt": promptData,
                  "temperature": 0.4,
                  "max_tokens": 64,
                  "top_p": 1,
                  "frequency_penalty": 0,
                  "presence_penalty": 0
                });
                if (_formKey.currentState!.validate()) {
                  var response =
                      await http.post(url, headers: headers, body: data);
                  if (response.statusCode == 200) {
                    print(response.body);
                    final gptData = gptDataFromJson(response.body);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            IdeasScreen(gptReponseData: gptData)));
                  }
                }
              },
              child: const Center(child: Text("Generate Gift Ideas")),
            ),
          ),
        ],
      ),
    ));
  }
}
