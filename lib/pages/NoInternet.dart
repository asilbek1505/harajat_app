import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NoInternetPage extends StatelessWidget {
  final VoidCallback onRetry;
  final bool isDarkMode;

  const NoInternetPage({
    Key? key,
    required this.onRetry,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? Color(0xFF121212) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      color: bgColor,
      padding: EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80, color: Colors.red),
            SizedBox(height: 20),
            Text(
              'No internet connection available'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text("retry".tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
