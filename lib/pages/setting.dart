import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:harajat_app/servise/auth_servise.dart';
import 'SharhPage.dart';

class SettingPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onDarkModeChanged;

  const SettingPage({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF7F7F7);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dark Mode Switch
            _buildSettingItem(
              context: context,
              icon: isDarkMode ? Icons.nightlight_round : Icons.sunny,
              iconColor: isDarkMode? Colors.tealAccent:Colors.deepOrange,
              title: "dark_mode".tr(),
              trailing: Switch.adaptive(
                value: isDarkMode,
                activeColor: Colors.tealAccent,
                onChanged: onDarkModeChanged,
              ),
            ),

            // Comments Section
            _buildSettingItem(
              context: context,
              icon: Icons.comment,
              iconColor:isDarkMode? Colors.tealAccent:Colors.deepOrange,
              title: "comment".tr(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SharhPage(isDarkMode: isDarkMode),
                  ),
                );
              },
            ),

            // Logout Button
            _buildSettingItem(
              context: context,
              icon: Icons.logout,
              iconColor: Colors.red,
              title: "logout".tr(),
              onTap: () async {
                await AuthServise.signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final cardColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
