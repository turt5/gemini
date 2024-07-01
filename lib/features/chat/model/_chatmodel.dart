import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatModel extends ChangeNotifier {
  List<Map<String, String>> messages = [];
  bool _isLoading = false;
  bool _isImageSelected=false;

  set isImageSelected(bool value){
    _isImageSelected=value;
    notifyListeners();
  }

  bool get getImageSelectionData => _isImageSelected;

  final List<Content> chatHistory = []; // Store chat history here

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
        final String apiKey = 'AIzaSyCr-N6Cfk1kQSh03qZT9IR6mcCT-W_g9eo'; // Load from .env file
        if (apiKey.isEmpty) {
          print('API key is missing');
          return;
        }

        // Initialize the generative model if not already initialized
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(),
        );

        // Prepare content for the AI response
        var content = Content.text(message);
        chatHistory.add(content); // Add message to chat history

        // Send the message to the AI server
        var chat = model.startChat(history: chatHistory);
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
