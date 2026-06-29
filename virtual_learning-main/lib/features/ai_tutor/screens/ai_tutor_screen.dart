import 'package:flutter/material.dart';

import '../../../core/theme/character_animation.dart';

class ComingSoonPages extends StatelessWidget {
  const ComingSoonPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask AI')),
      body: const Center(
        child: CharacterAnimation(
          text: 'COMING SOON',
          color: Color(0xFF239C16),
        ),
      ),
    );
  }
}

/*
import '../../../core/services/ai_service.dart';
import '../../../data/models/ai_message_model.dart';

class AiTutorScreen extends StatefulWidget {
  const AiTutorScreen({super.key});

  @override
  State<AiTutorScreen> createState() =>
      _AiTutorScreenState();
}

class _AiTutorScreenState
    extends State<AiTutorScreen> {
  final TextEditingController controller =
  TextEditingController();

  final AiService aiService = AiService();

  final List<AiMessageModel> messages = [];

  bool loading = false;

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    final userMessage =
    controller.text.trim();

    setState(() {
      messages.add(
        AiMessageModel(
          message: userMessage,
          isUser: true,
        ),
      );

      loading = true;
    });

    controller.clear();

    try {
      final response =
      await aiService.askQuestion(
        userMessage,
      );

      setState(() {
        messages.add(
          AiMessageModel(
            message: response,
            isUser: false,
          ),
        ),
      });
    } catch (e) {
      setState(() {
        messages.add(
          AiMessageModel(
            message:
            "Sorry, I could not answer that.",
            isUser: false,
          ),
        );
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Tutor"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                    const EdgeInsets.all(8),
                    padding:
                    const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? Colors.blue
                          : Colors.grey.shade300,
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Text(
                      msg.message,
                      style: TextStyle(
                        color: msg.isUser
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                    const InputDecoration(
                      hintText:
                      "Ask about histology...",
                    ),
                  ),
                ),
                IconButton(
                  icon:
                  const Icon(Icons.send),
                  onPressed:
                  loading ? null : sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


 */
