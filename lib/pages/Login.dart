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
    } else if (!email.contains('@')) {
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
          side: BorderSide(color: Colors.tealAccent, width: 2.0), // Rangni o'zgartirdik
        ),
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.tealAccent), // Rangni o'zgartirdik
            SizedBox(width: 10),
            Text(
              'Xatolik!',
              style: TextStyle(color: Colors.tealAccent), // Rangni o'zgartirdik
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
              style: TextStyle(color: Colors.tealAccent), // Rangni o'zgartirdik
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
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
                        color: Colors.tealAccent, // Rangni o'zgartirdik
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
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
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Kirish uchun telefon raqamingiz va parolingizni kiriting",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Email TextFormField
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email yoki telefon",
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white70),
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
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white70),
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
                        ? Center(child: CircularProgressIndicator(color: Colors.tealAccent)) // Rangni o'zgartirdik
                        : ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent, // Rangni o'zgartirdik
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Davom etish",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (_) => SignUp()));
                      },
                      child: Text(
                        "Ro'yxatdan o'tish",
                        style: TextStyle(color: Colors.tealAccent, fontSize: 16), // Rangni o'zgartirdik
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
