import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String text;
  final String email;
  final DateTime date;

  CommentModel({
    required this.text,
    required this.email,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'email': email,
    'timestamp': date,
  };

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      text: json['text'],
      email: json['email'],
      date: json['timestamp'],
    );
  }
}
