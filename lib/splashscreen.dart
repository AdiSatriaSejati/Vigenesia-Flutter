import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vigenesia/Screens/Login.dart';

/// [Route] change page animation
Route createRoute(Widget child) => PageRouteBuilder(
      transitionDuration: Duration(seconds: 2),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = animation.drive(Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(
                curve: Interval(0.0, 0.6, curve: Curves.easeInOutCubic))));

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: tween,
            child: child,
          ),
        );
      },
    );

class SplashScreen extends StatefulWidget {
  final String? title;

  const SplashScreen({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController writingController;
  late AnimationController colorController;
  late Animation<Color?> letterColor;
  late Animation<int> textAnimation;

  final String fullText = "Vigenesia";
  String animatedText = "";

  @override
  void initState() {
    super.initState();

    // Controller untuk animasi huruf
    writingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Durasi animasi
    );

    textAnimation = IntTween(begin: 0, end: fullText.length).animate(
      CurvedAnimation(
        parent: writingController,
        curve: Curves.easeInOut,
      ),
    );

    // Controller untuk efek warna
    colorController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    letterColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: colorController,
        curve: Curves.linear,
      ),
    );

    // Mulai animasi huruf
    writingController.addListener(() {
      setState(() {
        final currentLength = textAnimation.value;
        animatedText = fullText.substring(0, currentLength);
      });
    });

    // Mulai animasi
    writingController.forward().whenComplete(() {
      colorController.repeat(
          reverse: true); // Animasi warna dimulai setelah selesai menulis
    });

    // Timer untuk navigasi ke layar berikutnya
    Timer(const Duration(seconds: 6), navigateToLogin);
  }

  // Navigasi ke layar login setelah selesai animasi
  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      createRoute(Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(148, 243, 240, 240),
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: colorController,
              builder: (context, child) {
                return Text(
                  animatedText,
                  style: TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'zoyam', // Font kustom diterapkan
                    color: letterColor.value,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    writingController.dispose();
    colorController.dispose();
    super.dispose();
  }
}
