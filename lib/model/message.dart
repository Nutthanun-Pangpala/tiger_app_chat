import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp; // Update type to Timestamp

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.timestamp, // Update type to Timestamp
    required this.message,
  });

  // Convert Message to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp, // Update type to Timestamp
    };
  }
}
