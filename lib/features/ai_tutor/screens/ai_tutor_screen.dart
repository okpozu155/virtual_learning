
import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coming Soon'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 450,
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'COMING SOON...',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
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
        );
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