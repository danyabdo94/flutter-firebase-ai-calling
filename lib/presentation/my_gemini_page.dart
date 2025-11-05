// lib/gemini_page.dart
import 'package:flutter/material.dart';
import 'package:sidekik/infrastructure/gemini_service.dart';

class MyGeminiPage extends StatefulWidget {
  const MyGeminiPage({super.key, required this.title});
  final String title;

  @override
  State<MyGeminiPage> createState() => _MyGeminiPageState();
}

class _MyGeminiPageState extends State<MyGeminiPage> {
  final TextEditingController _promptController = TextEditingController();
  final GeminiService _geminiService =
      GeminiService(); // Create an instance of the service
  String _geminiResponse = '';
  bool _isLoading = false;

  // This method now calls our service
  Future<void> _callGeminiAI() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isLoading = true;
      _geminiResponse = '';
    });

    try {
      String response = "";
      if (prompt.toLowerCase().contains("code")) {
        response = await _geminiService.executeCode(prompt);
      } else if ([
        "who",
        "what",
        "when",
        "where",
        "which",
        "why",
        "how",
      ].any((word) => prompt.toLowerCase().startsWith(word))) {
        response = await _geminiService.fetchSearchResponse(prompt);
      } else {
        response = await _geminiService.fetchResponse(prompt);
      }

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _geminiResponse = response;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _geminiResponse = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ask Gemini AI anything:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                hintText: 'Enter your question or prompt...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _callGeminiAI,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Ask Gemini'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Gemini Response:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Thinking...'),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Text(
                          _geminiResponse.isEmpty
                              ? 'Ask a question to see Gemini\'s response here!'
                              : _geminiResponse,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
