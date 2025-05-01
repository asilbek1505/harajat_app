import 'package:flutter/material.dart';

import 'Login.dart'; // Login sahifang nomi shu bo‘lsa

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _currentIndex = 0;

  final List<Widget> _introWidgets = [
    introWidget(
      image: 'assets/img.png', // intro rasm 1
      title: "Xarajatlaringizni boshqaring",
      description: "Har kuni qayerga qancha pul sarflayotganingizni bilib boring.",
    ),
    introWidget(
      image: 'assets/img_1.png', // intro rasm 2
      title: "Tahlil qiling",
      description: "Diagramma va statistikalar orqali oson kuzating.",
    ),
    introWidget(
      image: 'assets/img_2.png', // intro rasm 3
      title: "Tejamkor bo‘ling",
      description: "Maqsadlaringizga erishish uchun pulni to‘g‘ri yo‘naltiring.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (_) => LoginPage(),
              ));
            },
            child: Text("Skip", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: _introWidgets.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _introWidgets[index];
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_introWidgets.length, (index) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 20.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.orange : Colors.white24,
                ),
              );
            }),
          ),
          _currentIndex == _introWidgets.length - 1
              ? Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => LoginPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text("Boshlash",style: TextStyle(color: Colors.white),),
            ),
          )
              : SizedBox(height: 50),

        ],
      ),
    );
  }
}

Widget introWidget({required String image, required String title, required String description}) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(image, height: 250),
        SizedBox(height: 30),
        Text(
          title,
          style: TextStyle(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
