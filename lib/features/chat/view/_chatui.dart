import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../provider/_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _handlePopupMenuSelection(String value) {
    if (value == 'clear_messages') {
      ref.read(chatController).clearMessages();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    double width = MediaQuery.of(context).size.width;

    // Listen to message changes and scroll to the bottom
    ref.listen(chatController, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent+300,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey.shade800,
        child: Center(
          child:Text('Coming Soon', style: TextStyle(color: Colors.white))
        ),
      ),
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Gem",
                style: GoogleFonts.silkscreen(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text("ini",
                style: GoogleFonts.silkscreen(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handlePopupMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'clear_messages',
                child: Text('Clear Messages'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: colorScheme.surface,
              child: ref.watch(chatController).messages.isEmpty
                  ? Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                itemCount: ref.watch(chatController).messages.length,
                itemBuilder: (context, index) {
                  final message = ref.watch(chatController).messages[index];
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message['sender'] == 'Me'
                              ? colorScheme.primary
                              : Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['sender']!,
                                  style: TextStyle(
                                    color: message['sender'] == 'Me'
                                        ? Colors.grey.shade200
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: width * 0.7, // Adjust the width as needed
                                  child: MarkdownBody(
                                    fitContent: true,
                                    data: message['message'] ?? '',
                                    styleSheet: MarkdownStyleSheet(
                                      p: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (ref.watch(chatController).messages.length - 1 == index &&
                          ref.watch(chatController).isLoading)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.all(10),
                          height: 30,
                          child: LoadingAnimationWidget.prograssiveDots(
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade900,
                ),
              ),
            ),
            height: 90,
            child: Center(
              child: SizedBox(
                width: width * 0.8,
                height: 60,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      child: IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.link,
                          color: Colors.grey,
                          size: 16,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    hintText: 'Type your message',
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        String text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          ref.read(chatController).addMessage(text, 'Me');
                          _controller.clear();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: const EdgeInsets.only(
                            right: 10, left: 10, top: 10, bottom: 10),
                        child: const FaIcon(
                          FontAwesomeIcons.paperPlane,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
