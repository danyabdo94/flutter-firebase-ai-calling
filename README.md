# Building your AI Sidekick with Gemini 
This guide provides a step-by-step process for building your very own AI Sidekick
with Gemini using Flutter and Firebase.

## Key Takeaways

This workshop will guide you through building a complete Flutter application powered by the Gemini API. By the end, you will have learned how to:

*   **Set Up Your Environment:** Configure a Flutter project with Firebase and the necessary AI dependencies.
*   **Separate Concerns:** Structure your app with a dedicated service class for AI logic, keeping your UI code clean and maintainable.
*   **Make Basic AI Calls:** Connect to the Gemini API and generate text content from user prompts.
*   **Tune Model Behavior:** Use `systemInstruction` to give your AI a specific persona and task, like acting as an ASCII art converter.
*   **Leverage Multimodality:** Go beyond text by providing images to the model and generating descriptions.
*   **Enforce Structured Output:** Use `responseSchema` to force the model to return predictable, structured JSON, making its output easier to parse and use in your application.

---



## Prerequisites

Before you begin, ensure you have the following installed:

* **Flutter SDK**: Make sure you have the latest version of the Flutter SDK installed on your machine.
* **Platform-Specific Tooling**:
    * For iOS development, you'll need **Xcode**.
    * For Android development, you'll need **Android Studio**.
* **A Firebase Project**: You should have an active Firebase project. If you don't have one, you can create one in the [Firebase console](https://console.firebase.google.com/).
1. Create a new Firebase Project
2. Type in any name
3. Continue and activate Gemini
4. You can disable Google Analytics if you want.
5. Go to AI-Logic & click on `Get Started` to enable the free gemini SDK for your App. (Please use the free Gemini Developer API)

## Step 1: Install Required Command Line Tools

You will need the Firebase CLI and the FlutterFire CLI to configure your project.

1.  **Install Required Command-Line Tools**

If you don't have it installed, open your terminal and run the following command. This requires `npm`, which comes with Node.js. [docs](https://firebase.google.com/docs/cli#mac-linux-npm)
```sh
npm install -g firebase-tools
```
2.  **Log into Firebase** by running the following command in your terminal: [docs](https://firebase.google.com/docs/flutter/setup?platform=ios)
```sh
firebase login
```
3.  **Install the FlutterFire CLI** by running the following command: [docs](https://firebase.google.com/docs/flutter/setup?platform=ios)
```sh
dart pub global activate flutterfire_cli
```

## Step 2: Create Your Flutter Project

Now that the tools are set up, let's create a new Flutter project for our AI Sidekick. Open your terminal, navigate to where you want to store your project, and run:

```sh
flutter create ai_sidekick
```

Once the project is created, navigate into its directory:

```sh
cd ai_sidekick
```

From now on, all commands should be run from within this `ai_sidekick` directory.

## Step 3: Configure Your App to Use Firebase

Now that you are in your project's directory, run the FlutterFire configuration command. This will link your Flutter app with your Firebase project.

```sh
flutterfire configure
```

This command will guide you through selecting the platforms you want to target and connecting to a Firebase project. It will generate a `lib/firebase_options.dart` configuration file for you.

## Step 4: Initialize Firebase in Your App

**Add the Firebase core plugin** to your project by running this command:
```sh
flutter pub add firebase_core
```

## Step 5: Updating our main.dart File

To get started, we need to update the `main.dart` file. This is the entry point of our Flutter app. We'll modify it to initialize Firebase when the app starts. This ensures that all Firebase services are available before any other part of the app runs. We also set `MyGeminiPage` as the home page of our app, which we will create in the next step.

 ```dart
 import 'package:flutter/material.dart';
 import 'package:firebase_core/firebase_core.dart';
 import 'gemini_page.dart';
 import 'firebase_options.dart';

 void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 runApp(const MyApp());
 }

 class MyApp extends StatelessWidget {
 const MyApp({super.key});

 // This widget is the root of your application.
 @override
 Widget build(BuildContext context) {
     return MaterialApp(
     title: 'Gemini AI Showcase',
     theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
     home: const MyGeminiPage(title: 'Gemini AI Showcase'),
     );
 }
 }
 ```

## Step 6: Creating the UI and a Service for our Sidekick

Now, let's build the app's foundation. We'll create the user interface and also set up a dedicated service class to handle our AI logic. This separation of concerns is a best practice that will make our code cleaner, more organized, and easier to expand later.

1.  **Create the `GeminiService`**
    
    Create a new file at `lib/gemini_service.dart`. This class will eventually contain all our Gemini API logic. For now, it will just have a placeholder method that simulates a network delay and returns a fixed response.

    ```dart
    // lib/gemini_service.dart
    class GeminiService {
      Future<String> generateContent(String prompt) async {
        // For now, simulate a delay
        await Future.delayed(const Duration(seconds: 2));
        return 'This is a placeholder response. Gemini AI integration will be implemented in the next step.';
      }
    }
    ```

2.  **Create the User Interface**

    Next, create the UI in a new file at `lib/gemini_page.dart`. This code sets up a text field for user input, a button to submit, and a display area for the response. Notice how it imports and uses the `GeminiService` we just created.

    ```dart
    // lib/gemini_page.dart
    import 'package:flutter/material.dart';
    import 'gemini_service.dart'; // Import the new service

    class MyGeminiPage extends StatefulWidget {
      const MyGeminiPage({super.key, required this.title});
      final String title;

      @override
      State<MyGeminiPage> createState() => _MyGeminiPageState();
    }

    class _MyGeminiPageState extends State<MyGeminiPage> {
      final TextEditingController _promptController = TextEditingController();
      final GeminiService _geminiService = GeminiService(); // Create an instance of the service
      String _geminiResponse = '';
      bool _isLoading = false;

      // This method now calls our service
      Future<void> _callGeminiAI() async {
        if (_promptController.text.trim().isEmpty) return;

        setState(() {
          _isLoading = true;
          _geminiResponse = '';
        });

        final response = await _geminiService.generateContent(_promptController.text.trim());

        setState(() {
          _isLoading = false;
          _geminiResponse = response;
        });
      }

      @override
      void dispose() {
        _promptController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Ask Gemini AI anything:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: _promptController,
                  decoration: const InputDecoration(hintText: 'Enter your question or prompt...', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _callGeminiAI,
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Ask Gemini'),
                ),
                const SizedBox(height: 24),
                const Text('Gemini Response:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: _isLoading
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Thinking...')],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Text(
                              _geminiResponse.isEmpty ? 'Ask a question to see Gemini\'s response here!' : _geminiResponse,
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
    ```

## Step 7: Implement the Gemini API in our Service

With the UI and service structure in place, it's time to connect to the real Gemini API. Thanks to our refactoring, we only need to update the `GeminiService`—the UI file remains completely unchanged.

1.  From your Flutter project directory, run this command to install the necessary plugin:
    ```bash
    flutter pub add firebase_ai
    ```
2.  Update your `lib/gemini_service.dart` file to import `firebase_ai` and implement the actual API call.

    ```dart
    // lib/gemini_service.dart
    import 'package:firebase_ai/firebase_ai.dart';

    class GeminiService {
      final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');

      Future<String> generateContent(String prompt) async {
        try {
          final response = await model.generateContent([Content.text(prompt)]);
          return response.text ?? 'No response received from Gemini.';
        } catch (e) {
          return 'Error: ${e.toString()}';
        }
      }
    }
    ```
    That's it! Your app is now fully connected to Gemini. The UI will call the service, which in turn calls the Gemini API and returns the response.

## Step 8: Tuning the Model with System Instructions

Let's give our AI Sidekick a specific personality. We can use `systemInstruction` to tell the model how to behave. We'll make it an ASCII art converter. Once again, we only need to modify our `GeminiService`.

1.  **Update the `GeminiService`**
    
    In `lib/gemini_service.dart`, add the `systemInstruction` to the `generativeModel` configuration.

    ```dart
    // lib/gemini_service.dart
    import 'package:firebase_ai/firebase_ai.dart';

    class GeminiService {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
        systemInstruction: Content.system('You are an ASCII art converter. Respond with only the ASCII art for the user\'s prompt, without any additional text or explanation.'),
      );

      Future<String> generateContent(String prompt) async {
        try {
          final response = await model.generateContent([Content.text(prompt)]);
          return response.text ?? 'No response received from Gemini.';
        } catch (e) {
          return 'Error: ${e.toString()}';
        }
      }
    }
    ```

Now, run the app again. If you ask for "a robot" or "a flower", Gemini will respond with ASCII art instead of a text description. You've successfully specialized your AI sidekick by cleanly separating your concerns!

## Step 9: Exploring Multimodal Prompts with Images

One of Gemini's most powerful features is its **multimodality**—the ability to understand and process information from different formats, not just text. You can combine text with images, videos, audio, and even PDF files in a single prompt. For this step, we'll explore this by building a feature to describe an image from a web URL.

To handle both our ASCII art task and this new image description task, we'll update our `GeminiService` to manage two slightly different model configurations.

1.  **Add the `http` Package**

    To fetch the image from a URL, we first need to add the `http` package to our project. Run the following command in your terminal:

    ```bash
    flutter pub add http
    ```

2.  **Update the `GeminiService` for Multimodal Prompts**

    Let's refactor `lib/gemini_service.dart`. We'll create two model instances: one for our ASCII art converter and a new one for multimodal tasks. We'll also add a new method, `describeImage`, to handle the image-based prompts.

    ```dart
    // lib/gemini_service.dart
    import 'dart:typed_data';
    import 'package:firebase_ai/firebase_ai.dart';
    import 'package:http/http.dart' as http;

    class GeminiService {
      // Model for our ASCII art converter
      final _asciiArtModel = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
        systemInstruction: Content.system('You are an ASCII art converter. Respond with only the ASCII art for the user\'s prompt, without any additional text or explanation.'),
      );

      // A separate model for general multimodal tasks
      final _multimodalModel = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');

      Future<String> getAsciiArt(String prompt) async {
        try {
          final response = await _asciiArtModel.generateContent([Content.text(prompt)]);
          return response.text ?? 'No response received from Gemini.';
        } catch (e) {
          return 'Error: ${e.toString()}';
        }
      }

      Future<String> describeImage(String imageUrl) async {
        try {
          final http.Response response = await http.get(Uri.parse(imageUrl));
          if (response.statusCode != 200) {
            return 'Failed to load image from URL.';
          }

          final Uint8List imageBytes = response.bodyBytes;

          final content = [
            Content.multi([
              TextPart('Describe this image in detail, including the main subject, setting, colors, and any visible text or objects.'),
              InlineDataPart('image/jpeg', imageBytes),
            ])
          ];

          final modelResponse = await _multimodalModel.generateContent(content);
          return modelResponse.text ?? 'Could not describe the image.';
        } catch (e) {
          return 'Error analyzing image: ${e.toString()}';
        }
      }
    }
    ```

3.  **Update the UI Logic**

    Finally, let's update `lib/gemini_page.dart` to decide which service method to call. For simplicity, we'll check if the input text looks like a URL for a JPEG image. We'll also rename the call to `getAsciiArt` for clarity.

    ```dart
    // In lib/gemini_page.dart's _MyGeminiPageState class

    Future<void> _callGeminiAI() async {
      final prompt = _promptController.text.trim();
      if (prompt.isEmpty) return;

      setState(() {
        _isLoading = true;
        _geminiResponse = '';
      });

      String response;
      // Simple check to see if the prompt is a URL for a JPEG image
      if (prompt.startsWith('http') && (prompt.endsWith('.jpg') || prompt.endsWith('.jpeg'))) {
        response = await _geminiService.describeImage(prompt);
      } else {
        response = await _geminiService.getAsciiArt(prompt);
      }

      setState(() {
        _isLoading = false;
        _geminiResponse = response;
      });
    }
    ```

Now, run your app. You can still ask for ASCII art, but if you paste in a URL to a JPEG image, Gemini will describe it for you! You have successfully implemented a multimodal AI feature.

## Step 10: Enforcing Structured JSON Output with a Response Schema

So far, we've been getting plain text back from the model. But what if you need the model to respond in a specific format that your app can easily parse? A **response schema** forces the model to output valid JSON that matches a structure you define. This is perfect for when you need predictable, structured data.

Let's apply this to our entire app. We will create a universal schema that asks for a `title` and `content`, and we'll configure both of our model functions to use it. For simplicity, our UI will just display the raw JSON response, showing that the structure is being enforced.

1.  **Update the `GeminiService` with a Universal Schema**

    We will now refactor `lib/gemini_service.dart` one last time. We'll define a single schema and a single `GenerationConfig`, and apply it to both of our models. We'll also update the prompts to explicitly ask for a JSON response and change the methods to return the raw JSON string.

    ```dart
    // lib/gemini_service.dart
    import 'dart:typed_data';
    import 'package:firebase_ai/firebase_ai.dart';
    import 'package:http/http.dart' as http;

    class GeminiService {
      late final GenerativeModel _asciiArtModel;
      late final GenerativeModel _multimodalModel;

      GeminiService() {
        // 1. Define a universal JSON schema for all responses
        final responseSchema = Schema.object(
          properties: {
            'title': Schema.string(description: "A creative, short title for the content."),
            'content': Schema.string(description: "The main generated content (e.g., ASCII art or image description)."),
          },
        );

        // 2. Create a single generation config to enforce JSON output
        final config = GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: responseSchema,
        );

        // 3. Initialize the ASCII art model with the config
        _asciiArtModel = FirebaseAI.googleAI().generativeModel(
          model: 'gemini-2.5-flash',
          systemInstruction: Content.system('You are an ASCII art converter. You must respond in JSON format that adheres to the provided schema, providing a title and the ASCII art as content.'),
          generationConfig: config,
        );

        // 4. Initialize the multimodal model with the same config
        _multimodalModel = FirebaseAI.googleAI().generativeModel(
          model: 'gemini-2.5-flash',
          generationConfig: config,
        );
      }

      Future<String> getAsciiArt(String prompt) async {
        try {
          final response = await _asciiArtModel.generateContent([Content.text(prompt)]);
          // Return the raw JSON string
          return response.text ?? '{"error": "No response from model"}';
        } catch (e) {
          return '{"error": "${e.toString()}"}';
        }
      }

      Future<String> describeImage(String imageUrl) async {
        try {
          final http.Response response = await http.get(Uri.parse(imageUrl));
          if (response.statusCode != 200) {
            return '{"error": "Failed to load image from URL."}';
          }

          final Uint8List imageBytes = response.bodyBytes;

          final content = [
            Content.multi([
              // Update the text part to ask for JSON
              TextPart('Describe this image in detail. You must respond in JSON format that adheres to the provided schema, providing a title and the description as content.'),
              InlineDataPart('image/jpeg', imageBytes),
            ])
          ];

          final modelResponse = await _multimodalModel.generateContent(content);
          // Return the raw JSON string
          return modelResponse.text ?? '{"error": "Could not describe the image."}';
        } catch (e) {
          return '{"error": "Error analyzing image: ${e.toString()}"}';
        }
      }
    }
    ```


Run the app one last time. Whether you ask for ASCII art or provide an image URL, the output will now be a clean, predictable JSON object. You have successfully enforced a response schema across multiple types of prompts!

# More detailed blog post
[Read more on blog post from Ivanna Kaceviča](https://itnext.io/exploring-interleaved-genai-output-smarter-text-and-image-generation-in-flutter-0f8d0875b420). Thanks!
