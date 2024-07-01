import 'package:flutter/material.dart';
import 'package:gemini/features/chat/view/_chatui.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                )),
            Expanded(
              flex: 2,
                child: Column(
              children: [
                Text(
                  'Start Conversation',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: width < 400
                          ? 23
                          : width > 400 && width < 600
                              ? 28
                              : 32,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    'When you create your account, you will be\nable to save your conversations and settings',
                    textAlign: TextAlign.center,style: TextStyle(
                      color: Colors.grey,
                    )),
              ],
            )),
            Expanded(
              flex: 1,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('Login',style: GoogleFonts.inter(
                       fontWeight: FontWeight.bold
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: Size(width, 50),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ChatPage()));
                      },
                      child: Text('Skip',style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        minimumSize: Size(width, 50),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
