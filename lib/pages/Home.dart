import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:harajat_app/pages/NoInternet.dart';
import 'package:harajat_app/pages/setting.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Harajat_page.dart';
import 'hisobotlar_page.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  bool isDarkMode = false;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
    _loadLocale();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    setState(() {
      _isConnected = isConnected;
    });
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLocale = prefs.getString('locale') ?? 'en';
    context.setLocale(Locale(savedLocale));
  }

  void changeDarkMode(bool value) async {
    setState(() {
      isDarkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  void changeLocale(String locale) async {
    context.setLocale(Locale(locale));
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', locale);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color accentColor = isDarkMode ? Colors.orange : const Color(0xFFFF5722);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'app_title'.tr(),
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.language, color: textColor),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 16,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: backgroundColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'language'.tr(),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: Image.asset('assets/img_3.png'),
                            ),
                            title: Text('english'.tr(), style: TextStyle(color: textColor)),
                            onTap: () {
                              changeLocale('en');
                              Navigator.of(context).pop();
                            },
                          ),
                          Divider(color: textColor.withOpacity(0.3)),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: Image.asset('assets/img_4.png'),
                            ),
                            title: Text('uzbek'.tr(), style: TextStyle(color: textColor)),
                            onTap: () {
                              changeLocale('uz');
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _isConnected
          ? PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HarajatPage(
            pageController: _pageController,
            isDarkMode: isDarkMode,
          ),
          HisobotlarPage(isDarkMode: isDarkMode),
          SettingPage(
            isDarkMode: isDarkMode,
            onDarkModeChanged: changeDarkMode,
          ),
        ],
      )
          : NoInternetPage(
        isDarkMode: isDarkMode,
        onRetry: _checkInternetConnection,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        selectedItemColor: accentColor,
        unselectedItemColor: textColor.withOpacity(0.6),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'expenses'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'reports'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings'.tr(),
          ),
        ],
      ),
    );
  }
}
