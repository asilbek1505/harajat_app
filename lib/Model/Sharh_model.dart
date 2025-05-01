class SharhModel {
  final String? id;
  final String text;
  final String email;
  final DateTime sana;

  SharhModel({this.id, required this.text, required this.email, required this.sana});

  Map<String, dynamic> toJson() => {
    "text": text,
    "email": email,
    "sana": sana.toIso8601String(),
  };

  factory SharhModel.fromJson(Map<String, dynamic> json, String id) {
    return SharhModel(
      id: id,
      text: json['text'],
      email: json['email'],
      sana: DateTime.parse(json['sana']),
    );
  }
}
