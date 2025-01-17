import 'package:flutter/services.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import 'package:vigenesia/Screens/login.dart';
import 'dart:math';
import 'main.dart';
import 'package:flutter/gestures.dart';

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  String baseurl = url;

  Future postRegister(
      String nama, String profesi, String email, String password) async {
    dynamic data = {
      'nama': nama,
      'profesi': profesi,
      'email': email,
      'password': password
    };
    try {
      final response = await dio.post('$baseurl/api/registrasi',
          data: data,
          options: Options(headers: {'content-Type': 'application/json'}));
      print('Respon -> ${response.data} + ${response.statusCode}');
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Failed To Load $e');
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController profesiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Background Gradient
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: Container(
                child: Transform.rotate(
                  angle: -pi / 3.5,
                  child: ClipPath(
                    clipper: ClipPainter(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffE6E6E6),
                            Color(0xff14279B),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Main Content
            SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * .2),
                      // Title Section
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Vigen',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'zoyam',
                            color: Color(0xff14279B),
                            letterSpacing: 3,
                          ),
                          children: [
                            TextSpan(
                              text: 'esia',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'zoyam',
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'paul',
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 50),
                      // Form Section
                      Form(
                        child: Column(
                          children: [
                            // Name Input with Icon
                            FormBuilderTextField(
                              name: 'name',
                              controller: nameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.blueAccent),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                labelText: 'Nama',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Profesi Input with Icon
                            FormBuilderTextField(
                              name: 'profesi',
                              controller: profesiController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.work,
                                    color: Colors.blueAccent),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                labelText: 'Profesi',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Email Input with Icon
                            FormBuilderTextField(
                              name: 'email',
                              controller: emailController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email,
                                    color: Colors.blueAccent),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Password Input with Icon
                            FormBuilderTextField(
                              obscureText: true,
                              name: 'password',
                              controller: passwordController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock,
                                    color: Colors.blueAccent),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Register Button
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await postRegister(
                                    nameController.text,
                                    profesiController.text,
                                    emailController.text,
                                    passwordController.text,
                                  ).then((value) {
                                    if (value != null) {
                                      Navigator.pop(context);
                                      Flushbar(
                                        message: 'Berhasil Registrasi',
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.greenAccent,
                                        flushbarPosition: FlushbarPosition.TOP,
                                      ).show(context);
                                    } else {
                                      Flushbar(
                                        message:
                                            'Check Your Fields Before Register',
                                        duration: const Duration(seconds: 5),
                                        backgroundColor: Colors.redAccent,
                                        flushbarPosition: FlushbarPosition.TOP,
                                      ).show(context);
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 243, 238, 238),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Login Link
                            RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Login here',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Login(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
