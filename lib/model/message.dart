import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp; // Updated type to Timestamp
  final String senderUsername;
  final String receiverUsername;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.timestamp, // Updated type to Timestamp
    required this.message,
    required this.senderUsername,
    required this.receiverUsername, // Added missing 'this' keyword
  });

  // Convert Message to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'senderUsername': senderUsername,
      'receiverUsername': receiverUsername, // Added missing field
    };
  }
}
