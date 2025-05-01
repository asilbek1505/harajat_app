import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';  // Import for localization
import '../Model/Comment_Model.dart';
import '../servise/auth_servise.dart';
import '../servise/db_servsie.dart';

class SharhPage extends StatefulWidget {
  final bool isDarkMode;

  SharhPage({required this.isDarkMode, Key? key}) : super(key: key);

  @override
  _SharhPageState createState() => _SharhPageState();
}

class _SharhPageState extends State<SharhPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    final comment = CommentModel(
      text: _commentController.text.trim(),
      email: AuthServise.currentUserEmail()??'',
      date: DateTime.now(),
    );

    await DBServise.storeComment(comment);

    _commentController.clear();
    setState(() => isLoading = false);
  }

  String _formatDate(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.deepPurple,
      appBar: AppBar(
        title: Text("Fikr bildirish".tr(), style: TextStyle(fontWeight: FontWeight.bold)),  // Translated
        backgroundColor: isDark ? Colors.black : Colors.deepPurple,
        foregroundColor: isDark ? Colors.white : Colors.black,
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Hozircha sharhlar yo'q".tr(), style: TextStyle(color: Colors.white)));  // Translated
                }

                final comments = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final data = comments[index];
                    final timestamp = (data['timestamp'] as Timestamp).toDate();
                    return Card(
                      elevation: 3,
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.comment, color: Colors.deepPurple),
                        title: Text(
                          data['text'] ?? '',
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        ),
                        subtitle: Text(
                          data['email'] ?? 'Anonim',
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
                        ),
                        trailing: Text(
                          _formatDate(timestamp),
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildCommentInput(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(bool isDarkMode) {
    return Column(
      children: [
        TextField(
          controller: _commentController,
          maxLines: 3,
          maxLength: 300,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: "Fikringizni yozing...".tr(),  // Translated
            filled: true,
            fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.white70 : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed:_submitComment,
            icon: const Icon(Icons.send),
            label: isLoading
                ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
                : Text("Yuborish".tr(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),  // Translated
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
