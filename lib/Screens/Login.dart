import 'package:flutter/services.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import 'main.dart';
import 'registrasi.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigenesia/Models/login_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  // Future for handling login API
  Future postLogin(String email, String password) async {
    String baseurl = url;
    Map<String, dynamic> data = {'email': email, 'password': password};
    try {
      final response = await dio.post('$baseurl/api/login',
          data: data,
          options: Options(headers: {'content-Type': 'application/json'}));
      print('Respon -> ${response.data} + ${response.statusCode}');
      if (response.statusCode == 200) {
        final loginModel = LoginModels.fromJson(response.data);
        return loginModel;
      }
    } catch (e) {
      print('Failed To Load $e');
    }
    return null;
  }

  // Controllers for email and password
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            // Background Gradient
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: Container(
                child: Transform.rotate(
                  angle: -pi / 3.5,
                  child: ClipPath(
                    clipper:
                        ClipPainter(), // Pastikan ClipPainter didefinisikan
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
                      // Logo Section
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
                        'login',
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
                        key: _fbKey,
                        child: Column(
                          children: [
                            // Email Input with icon
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

                            // Password Input with icon
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

                            // Sign In Button with gradient
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await postLogin(emailController.text,
                                          passwordController.text)
                                      .then((value) => {
                                            if (value != null)
                                              {
                                                setState(() {
                                                  var id = value.data.iduser;
                                                  var name = value.data.nama;
                                                  SharedPreferences
                                                      .getInstance();
                                                  prefs.setString('email',
                                                      value.data.email);
                                                  prefs.setString(
                                                      'nama', value.data.nama);
                                                  prefs.setString(
                                                      'id', value.data.iduser);
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MainScreens(
                                                        nama: name,
                                                        idUser: id,
                                                      ),
                                                    ),
                                                  );
                                                })
                                              }
                                            else if (value == null)
                                              {
                                                Flushbar(
                                                  message:
                                                      'Check Your Email / Password',
                                                  duration: const Duration(
                                                      seconds: 5),
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  flushbarPosition:
                                                      FlushbarPosition.TOP,
                                                ).show(context)
                                              }
                                          });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Sign Up Text Link
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Don\'t have an account? ',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const Register()),
                                        );
                                      },
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
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
