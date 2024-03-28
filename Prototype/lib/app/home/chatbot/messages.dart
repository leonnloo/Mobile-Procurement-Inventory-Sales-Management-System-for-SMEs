import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final List messages;
  const MessagesScreen({super.key, required this.messages});

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
      controller: _scrollController,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: widget.messages[index]['isUserMessage']
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomRight:
                        Radius.circular(widget.messages[index]['isUserMessage'] ? 0 : 20),
                    topLeft:
                        Radius.circular(widget.messages[index]['isUserMessage'] ? 20 : 0),
                  ),
                  color: widget.messages[index]['isUserMessage'] ? Theme.of(context).colorScheme.secondaryContainer : Colors.grey[300],
                ),
                constraints: BoxConstraints(maxWidth: w * 2 / 3),
                child: Text(widget.messages[index]['message']),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, i) => const Padding(padding: EdgeInsets.only(top: 10)),
      itemCount: widget.messages.length,
    );
  }

  @override
  void didUpdateWidget(covariant MessagesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
