fetchSocialPost(int postId) async {
  await Future.delayed(const Duration(seconds: 1));
  return {
    'postId': postId,
    'content':
        'This is a sample social media post content for post ID $postId.',
    'author': 'User_$postId',
    'likes': 120 + postId,
    'comments': 15 + postId,
  };
}
