import 'package:flutter/material.dart';

import '../servise/auth_servise.dart';
import 'Home.dart';
import 'SignUp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // FormKey
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;


  String? _validateEmail(String? email) {
    if (email!.isEmpty) {
      return 'Emailni kiriting!';
    }else if (!email.contains('@')){
      return '@ belgisini kiriting!';
    }
    return null;
  }

  String? _validatePassword(String? parol) {
    if (parol!.isEmpty) {
      return 'Parolni kiriting!';
    }
    return null;
  }

  void login() async {
    if (!_formKey.currentState!.validate()) return; // Formni tekshirish

    setState(() {
      isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      final user = await AuthServise.loginUser(email, password);
      setState(() {
        isLoading = false;
      });
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Home()));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.orange, width: 2.0),
        ),
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.orange),
            SizedBox(width: 10),
            Text(
              'Xatolik!',
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(color: Colors.orange),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // FormKey
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Harajatlar APP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Xush kelibsiz!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Kirish uchun telefon raqamingiz va parolingizni kiriting",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 20),

                  // Email TextFormField
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email yoki telefon",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: false,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.white),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      // Har doim emailni kichik harflarga aylantiradi
                      _emailController.value = TextEditingValue(
                        text: value.toLowerCase(),
                        selection: TextSelection.collapsed(offset: value.length),
                      );
                    },
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 10),

                  // Parol TextFormField
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Parol",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: false,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      _passwordController.value = TextEditingValue(
                        text: value.toLowerCase(),
                        selection: TextSelection.collapsed(offset: value.length),
                      );
                    },
                    validator: _validatePassword,
                  ),
                  SizedBox(height: 20),

                  // Loading indicator yoki normal tugma
                  isLoading
                      ? Center(child: CircularProgressIndicator(color: Colors.orange))
                      : ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text("Davom etish",style: TextStyle(color: Colors.white),),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => SignUp()));
                    },
                    child: Text(
                      "Ro'yxatdan o'tish",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
