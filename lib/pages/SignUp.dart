import 'package:flutter/material.dart';
import '../Model/Member.dart';
import '../servise/auth_servise.dart';
import '../servise/db_servsie.dart';
import '../servise/shared_perference.dart';
import 'Home.dart';
import 'Login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;

  String? _validateEmail(String? email) {
    if (email!.isEmpty) {
      return 'Emailni kiriting!';
    } else if (!email.contains('@')) {
      return 'Emailda "@" belgisi bo‘lishi kerak!';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password!.isEmpty) {
      return 'Parolni kiriting!';
    } else if (password.length < 6) {
      return 'Parol kamida 6 ta belgidan iborat bo‘lishi kerak!';
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Parolda kamida bitta raqam bo‘lishi kerak!';
    }
    return null;
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim().toLowerCase();
      String password = _passwordController.text.trim().toLowerCase();
      String name = _nameController.text.trim();

      setState(() {
        isLoading = true;
      });

      var response = await AuthServise.signUp(email, password, name);

      if (response != null) {
        Member member = Member(email, name);
        await DBServise.storeMember(member);
        await SharedPerference.storeName(email, name);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Home()),
        );
      } else {
        showMessage("Ro‘yxatdan o‘tishda xatolik yuz berdi.");
      }

      setState(() {
        isLoading = false;
      });
    }
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
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Harajatlar APP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
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
                      "Ro'yxatdan o'tish uchun ma'lumotlarni kiriting",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 20),

                    // Ism
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration("Ismingiz", Icons.person),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ismingizni kiriting!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration("Email yoki telefon", Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        _emailController.value = TextEditingValue(
                          text: value.toLowerCase(),
                          selection: TextSelection.collapsed(offset: value.length),
                        );
                      },
                      validator: _validateEmail,
                    ),
                    SizedBox(height: 12),

                    // Parol
                    TextFormField(
                      controller: _passwordController,
                      decoration: _inputDecoration(
                        "Parol",
                        Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
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

                    isLoading
                        ? Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
                        : ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Ro'yxatdan o'tish",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 12),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Kirish sahifasiga o'tish",
                        style: TextStyle(color: Colors.cyanAccent),
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

  InputDecoration _inputDecoration(String label, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      prefixIcon: Icon(icon, color: Colors.white),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.cyanAccent),
      ),
      errorStyle: TextStyle(color: Colors.redAccent),
    );
  }
}
