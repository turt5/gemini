import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatModel extends ChangeNotifier {
  List<Map<String, dynamic>> messages = [];
  bool _isLoading = false;
  final String apiKey = 'AIzaSyCr-N6Cfk1kQSh03qZT9IR6mcCT-W_g9eo';
  XFile? _imageFile;

  set image(XFile? value) {
    _imageFile = value;
    notifyListeners();
  }

  XFile? get getImage => _imageFile;

  File? getImageAsFile() {
    if (_imageFile != null) {
      return File(_imageFile!.path);
    } else {
      return null;
    }
  }

  void clearImage() {
    _imageFile = null;
    notifyListeners();
  }

  final List<Content> chatHistory = [];

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> get getMessages => messages;

  void clearMessages() {
    messages.clear();
    notifyListeners();
  }

  Future<void> addMessageWithImage(String message, String sender) async {
    if (sender == "Me") {
      messages.add({'message': message, 'sender': sender, 'image': getImageAsFile()});
      notifyListeners();

      try {
        isLoading = true;

        if (_imageFile == null) {
          print('No image selected');
          return;
        }

        if (apiKey.isEmpty) {
          print('API key is missing');
          return;
        }

        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(),
        );

        // Read image bytes and convert to Uint8List
        Uint8List imageBytes = await _getImageBytes();

        var content = Content.multi([
          TextPart(message),
          DataPart('image/png', imageBytes),
        ]);

        chatHistory.add(content); // Add message to chat history

        var chat = model.startChat(history: chatHistory);
        var response = await chat.sendMessage(content);

        messages.add({'message': response.text!, 'sender': 'AI'});
        notifyListeners();
      } catch (e) {
        print('Error: $e');
      } finally {
        isLoading = false;
      }
    }
  }

  Future<Uint8List> _getImageBytes() async {
    if (_imageFile != null) {
      try {
        List<int> bytes = await _imageFile!.readAsBytes();
        return Uint8List.fromList(bytes);
      } catch (e) {
        print('Error reading image bytes: $e');
        rethrow; // Re-throw the error to handle it further up the call stack
      }
    } else {
      throw Exception('No image file available');
    }
  }

  Future<void> addMessage(String message, String sender) async {
    if (sender == 'Me') {
      messages.add({'message': message, 'sender': sender});
      notifyListeners();

      try {
        isLoading = true;

        if (apiKey.isEmpty) {
          print('API key is missing');
          return;
        }

        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(),
        );

        var content = Content.text(message);
        chatHistory.add(content); // Add message to chat history

        var chat = model.startChat(history: chatHistory);
        var response = await chat.sendMessage(content);

        messages.add({'message': response.text!, 'sender': 'AI'});
        notifyListeners();
      } catch (e) {
        print('Error: $e');
      } finally {
        isLoading = false;
      }
    } else {
      print('Message not sent');
    }
  }
}
