import 'package:firebase_ai/firebase_ai.dart';
import 'package:sidekik/infrastructure/location_service.dart';
import 'package:sidekik/infrastructure/social_post_service.dart';
import 'package:sidekik/infrastructure/tools.dart';
import 'dart:async';

class GeminiService {
  late final GenerativeModel _multimodalModel;
  late final GenerativeModel _codeExecutionModel;

  GeminiService() {
    _multimodalModel = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      tools: [
        Tool.functionDeclarations([fetchLocationDataTool, fetchSocialPostTool]),
      ],
    );

    _codeExecutionModel = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      tools: [Tool.codeExecution()],
    );
  }

  Future<String> executeCode(String text) async {
    final codeExecutionChat = _codeExecutionModel.startChat();
    final response = await codeExecutionChat.sendMessage(Content.text(text));

    final buffer = StringBuffer();
    for (final part in response.candidates.first.content.parts) {
      if (part is TextPart) {
        buffer.writeln(part.text);
      } else if (part is ExecutableCodePart) {
        buffer.writeln('Executable Code:');
        buffer.writeln('Language: ${part.language}');
        buffer.writeln('Code:');
        buffer.writeln(part.code);
        // saveCodeToFile(part.code); //not on web
      } else if (part is CodeExecutionResultPart) {
        buffer.writeln('Code Execution Result:');
        buffer.writeln('Outcome: ${part.outcome}');
        buffer.writeln('Output:');
        buffer.writeln(part.output);
      }
    }
    return buffer.toString();
  }

  Future<String> fetchResponse(String text) async {
    final chat = _multimodalModel.startChat();
    var response = await chat.sendMessage(Content.text(text));

    final functionCalls = response.functionCalls.toList();
    // When the model responds with one or more function calls, invoke the function(s).
    if (functionCalls.isNotEmpty) {
      for (final functionCall in functionCalls) {
        switch (functionCall.name) {
          case 'fetchSocialPost':
            var id = functionCall.args['postId']! as int;
            final functionResult = await fetchSocialPost(id);
            response = await chat.sendMessage(
              Content.functionResponse(functionCall.name, functionResult),
            );
            break;

          case 'fetchLocationData':
            var id = functionCall.args['locationId']! as int;
            final functionResult = await fetchLocationData(id);
            response = await chat.sendMessage(
              Content.functionResponse(functionCall.name, functionResult),
            );
          default:
            throw UnimplementedError(
              'Function ${functionCall.name} not implemented',
            );
        }
      }
    }
    return response.text ?? 'No response from AI';
  }
}

