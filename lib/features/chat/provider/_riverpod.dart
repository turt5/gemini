import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini/features/chat/model/_chatmodel.dart';

final chatController = ChangeNotifierProvider<ChatModel>((ref) => ChatModel());