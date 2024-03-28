// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/home/chatbot/messages.dart';
import 'package:prototype/util/chatbot_util.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final ChatbotUtil chatbotUtil = ChatbotUtil();
  List<Map<String, dynamic>> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'ChatBot'),
      body: Column(
        children: [
          Expanded(child: MessagesScreen(messages: messages),),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  )
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // response(_controller.text);
                    sendMessage(_controller.text);
                    _controller.clear();
                  }),
              ]
            ),
          )
        ],
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    }
    else {
      setState(() {
        addMessage(text, true);
      });

      // print(dialogFlowtter.detectIntent(queryInput: QueryInput(text: TextInput(text: text))));
      // print(dialogFlowtter.credentials);
      // DetectIntentResponse response = await dialogFlowtter.detectIntent(queryInput: QueryInput(text: TextInput(text: text, languageCode: "en",)));
      final response = await chatbotUtil.sendMessage(text);
      if (response.statusCode == 200) {
        final message = jsonDecode(response.body)['response'];
        setState(() {
          addMessage(message);
        });
      }
    }
  }


  addMessage(String message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }
}