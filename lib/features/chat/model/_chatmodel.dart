import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatModel extends ChangeNotifier {
  List<Map<String, String>> messages = [];
  bool _isLoading = false;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  List<Map<String, String>> get getMessages => messages;

  void clearMessages() {
    messages.clear();
    notifyListeners();
  }

  Future<void> addMessage(String message, String sender) async {
    if (sender == 'Me') {
      messages.add({'message': message, 'sender': sender});
      notifyListeners();

      try {
        // Set loading to true
        isLoading = true;

        // Load the API key from the environment
        final String apiKey =  'AIzaSyCr-N6Cfk1kQSh03qZT9IR6mcCT-W_g9eo';
        if (apiKey.isEmpty) {
          print('API key is missing');
          return;
        }

        // Initialize the generative model
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(),
        );

        // Send the message to the AI server
        var content = Content.text(message);
        var chat = model.startChat(history: [content]);
        var response = await chat.sendMessage(content);

        // Add the AI response to the chat
        messages.add({'message': response.text!, 'sender': 'AI'});
        notifyListeners();
      } catch (e) {
        print('Error: $e');
      } finally {
        // Set loading to false
        isLoading = false;
      }
    } else {
      print('Message not sent');
    }
  }
}
