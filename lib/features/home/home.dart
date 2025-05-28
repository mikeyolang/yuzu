import 'package:flutter/material.dart';
import 'package:yuzu/common/pickfile.dart';

import 'package:yuzu/features/game/game.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _uploadFile(BuildContext context) async {
    final letterCombinations =
        await FilePickerService.pickAndProcessFile(context);

    if (letterCombinations == null) return;

    if (letterCombinations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No valid word combinations found in file')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Found ${letterCombinations.length} letter combinations!'),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          letterCombinations: letterCombinations,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if there's a previous session available
    bool hasPreviousSession =
        false; // This would be determined by your app state

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3E0),
              Color(0xFFFFE0B2)
            ], // Soft orange gradient
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA726),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Y",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App Name and Tagline
                  const Text(
                    "Yuzu",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE65100),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Unscramble your potential, one word at a time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF795548),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Upload Button
                  ElevatedButton(
                    onPressed: () => _uploadFile(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFFF9800),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.file_upload_outlined, size: 24),
                        SizedBox(width: 12),
                        Text(
                          "Upload Word File",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Statistics Button
                  ElevatedButton(
                    onPressed: () => null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF9800),
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                            color: Color(0xFFFF9800), width: 2),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bar_chart, size: 24),
                        SizedBox(width: 12),
                        Text(
                          "View Statistics",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Resume Session Button (conditionally displayed)
                  // To enable this button, set hasPreviousSession = true when a session exists.
                  // if (hasPreviousSession)
                  //   TextButton(
                  //     onPressed: () => _resumeSession(context),
                  //     style: TextButton.styleFrom(
                  //       foregroundColor: const Color(0xFFE65100),
                  //     ),
                  //     child: const Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(Icons.play_arrow, size: 20),
                  //         SizedBox(width: 8),
                  //         Text(
                  //           "Resume Previous Session",
                  //           style: TextStyle(fontSize: 16),
                  //         ),
                  //       ],
                  //     ),
                  //   ),

                  const Spacer(),

                  // Version info at bottom
                  const Text(
                    "Yuzu v1.0.0",
                    style: TextStyle(
                      color: Color(0xFF795548),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
