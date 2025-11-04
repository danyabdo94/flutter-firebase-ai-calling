import 'package:firebase_ai/firebase_ai.dart';

final fetchLocationDataTool = FunctionDeclaration(
  'fetchLocationData',
  'Get the location data from an ID',
  parameters: {
    'locationId': Schema.number(
      description: 'the location id in form of number',
    ),
  },
);

final fetchSocialPostTool = FunctionDeclaration(
  'fetchSocialPost',
  'Get the social post data from an ID',
  parameters: {
    'postId': Schema.number(
      description: 'the social post id in form of number',
    ),
  },
);
