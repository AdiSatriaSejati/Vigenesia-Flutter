import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vigenesia/Screens/add_page.dart';
import 'package:vigenesia/Screens/home.dart';
import 'search_page.dart';
import 'package:vigenesia/Screens/drawer.dart'; // Pastikan ini adalah file drawer Anda yang terpisah
import 'package:vigenesia/Screens/profile.dart';
import 'package:vigenesia/widgets/animated_bottom_navigation.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class MainScreens extends StatefulWidget {
  final String idUser;
  final String nama;
  const MainScreens({Key? key, required this.nama, required this.idUser})
      : super(key: key);
  @override
  MainScreensState createState() => MainScreensState();
}

class MainScreensState extends State<MainScreens> {
  String baseurl = url;
  TextEditingController postController =
      TextEditingController(); // Controller untuk TextField
  List<String> posts = []; // Menyimpan daftar postingan

  // Fungsi untuk mendapatkan data motivasi
  Future<void> getDataMotivasi() async {
    // Logika untuk mendapatkan data motivasi dari API
    // Misalnya, setelah mendapatkan data, tambahkan ke daftar posts
    // posts = hasil dari API;
    setState(() {}); // Memperbarui UI
  }

  // Fungsi untuk mengirimkan postingan ke API
  Future sendMotivasi(String motivasi) async {
    dynamic body = {'isi_motivasi': motivasi, 'iduser': widget.idUser};
    try {
      final response = await dio.post(
        '$baseurl/api/dev/POSTmotivasi',
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      posts.add(motivasi); // Menambahkan postingan baru ke daftar
      return response; // Mengembalikan response
    } catch (e) {
      print('Error di -> $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataMotivasiUser(widget.idUser);
    getDataMotivasi();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Fungsi untuk menangani pencarian
  void handleSearch() {
    // Logika untuk menangani pencarian
    // Misalnya, navigasi ke halaman pencarian
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SearchPage()), // Ganti dengan halaman pencarian yang sesuai
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(
        // Memanggil drawer yang Anda buat di file terpisah
        displayName: widget.nama,
        fullName: widget.nama,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20.0,
              spreadRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Bagian untuk menulis posting
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  margin:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openDrawer(),
                        child: CircleAvatar(
                          backgroundColor: Colors.purpleAccent,
                          child: Text(
                            widget.nama.isNotEmpty ? widget.nama[0] : 'U',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: postController,
                          maxLines: null,
                          style: const TextStyle(fontSize: 16.0),
                          decoration: InputDecoration(
                            hintText: "Apa yang sedang terjadi?",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontStyle: FontStyle.italic,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Colors.blueAccent,
                                width: 2.0,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send,
                                  color: Colors.blueAccent),
                              onPressed: () async {
                                String motivasi = postController.text;
                                await sendMotivasi(motivasi);
                                postController.clear();
                                await getDataMotivasi();
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Motivasi berhasil dikirim!')),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Konten Utama
            Expanded(child: Home(posts: posts)),
            // Tambahkan AnimatedBottomNavigation di sini
            AnimatedBottomNavigation(
              icons: [Icons.home, Icons.search, Icons.person],
              onTapChange: (index) {
                if (index == 0) {
                  // Logika untuk tab home
                } else if (index == 1) {
                  handleSearch(); // Panggil fungsi pencarian
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                              id: widget.idUser,
                              fromPage: "home",
                            )),
                  );
                }
              },
              currentIndex: 0, // Ganti dengan index yang sesuai
            ),
          ],
        ),
      ),
    );
  }
}
