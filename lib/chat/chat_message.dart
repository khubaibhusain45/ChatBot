class ChatMessage {
  final int id;
  final String role; // 'user' or 'model'
  final String message;

  ChatMessage({
    required this.id,
    required this.role,
    required this.message,
  });
}
