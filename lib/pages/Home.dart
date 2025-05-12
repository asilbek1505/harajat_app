import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harajat_app/pages/Harajat_page.dart';
import 'package:harajat_app/pages/NoInternet.dart';
import 'package:harajat_app/pages/hisobotlar_page.dart';
import 'package:harajat_app/pages/setting.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  bool isDarkMode = false;
  bool _isConnected = true;
  StreamSubscription<InternetConnectionStatus>? _listener;
  double monthlyBudget = 10000000.0;
  double monthlyExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
    _loadLocale();
    _loadBudget();
    _checkInternetConnection();

    if (!kIsWeb) {
      _listener = InternetConnectionChecker().onStatusChange.listen((status) {
        if (mounted) {
          setState(() {
            _isConnected = status == InternetConnectionStatus.connected;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _listener?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    if (kIsWeb) {
      if (mounted) {
        setState(() {
          _isConnected = true;
        });
      }
    } else {
      bool isConnected = await InternetConnectionChecker().hasConnection;
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    }
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        isDarkMode = prefs.getBool('isDarkMode') ?? false;
      });
    }
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String savedLocale = prefs.getString('locale') ?? 'en';
    if (mounted) {
      await context.setLocale(Locale(savedLocale));
    }
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        monthlyBudget = prefs.getDouble('monthlyBudget') ?? 10000000.0;
        monthlyExpense = prefs.getDouble('monthlyExpense') ?? 0.0;
      });
    }
  }

  Future<void> _updateBudget(double newBudget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('monthlyBudget', newBudget);
    if (mounted) {
      setState(() {
        monthlyBudget = newBudget;
      });
    }
  }

  void changeDarkMode(bool value) async {
    if (mounted) {
      setState(() {
        isDarkMode = value;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  void changeLocale(String locale) async {
    if (mounted) {
      await context.setLocale(Locale(locale));
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
    _pageController.jumpToPage(index);
  }

  void _editMonthlyBudget(BuildContext context) {
    TextEditingController budgetController =
    TextEditingController(text: monthlyBudget.toString());
    Color textColor = isDarkMode ? Colors.tealAccent : Colors.black;
    Color backgroundColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    Color accentColor = isDarkMode ? Colors.tealAccent : const Color(0xFFFF5722);

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: backgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'edit_monthly_budget'.tr(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'monthly_budget'.tr(),
                    labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: accentColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'cancel'.tr(),
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        double? newBudget = double.tryParse(budgetController.text);
                        if (newBudget != null && newBudget > 0) {
                          await _updateBudget(newBudget);
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('invalid_budget'.tr()),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text(
                        'save'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color accentColor = isDarkMode ? Colors.tealAccent : const Color(0xFFFF5722);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                      padding: const EdgeInsets.all(20),
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
                          const SizedBox(height: 20),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: Image.asset('assets/img_3.png'),
                            ),
                            title: Text('english'.tr(),
                                style: TextStyle(color: textColor)),
                            onTap: () {
                              changeLocale('en');
                              Navigator.of(context).pop();
                            },
                          ),
                          Divider(color: textColor.withOpacity(0.3)),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: Image.asset('assets/img_4.png'),
                            ),
                            title: Text('uzbek'.tr(),
                                style: TextStyle(color: textColor)),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black, Colors.grey[900]!]
                : [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isConnected
            ? PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            if (mounted) {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          children: [
            HarajatPage(pageController: _pageController, isDarkMode: isDarkMode, monthlyBudget: monthlyBudget, onEditMonthlyBudget: _editMonthlyBudget
            ),
            HisobotlarPage(isDarkMode: isDarkMode, onEditMonthlyBudget: _editMonthlyBudget,),
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
            icon: const Icon(Icons.attach_money),
            label: 'expenses'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: 'reports'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'settings'.tr(),
          ),
        ],
      ),
    );
  }
}