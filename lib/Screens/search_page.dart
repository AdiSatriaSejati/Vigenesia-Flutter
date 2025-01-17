import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'profile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> allUsers = [];
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      var dio = Dio();
      String url = 'http://192.168.18.64/vigenesia_kelompok3/api/user';

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        setState(() {
          allUsers = data.map((user) => user['nama']).toList().cast<String>();
        });
      } else {
        showError('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error fetching users: $e');
    }
  }

  void updateSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = [];
      } else {
        searchResults = allUsers
            .where((user) => user.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void showError(String message) {
    // Menambahkan logika untuk menampilkan pesan kesalahan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.blue, Colors.purple],
            tileMode: TileMode.clamp,
          ).createShader(bounds),
          child: Text(
            'Pencarian Pengguna',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari pengguna...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFE0E0E0),
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                ),
                onChanged: updateSearchResults,
              ),
              SizedBox(height: 16),
              Expanded(
                child: searchResults.isNotEmpty
                    ? ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              title: Text(
                                searchResults[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                              leading: CircleAvatar(
                                child: Text(
                                  searchResults[index][0].toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Color(0xFF6200EA),
                              ),
                              onTap: () {
                                // Hapus pesan "Anda memilih"
                              },
                              trailing: IconButton(
                                icon: Icon(Icons.person_2,
                                    color: Colors.blueAccent),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Profile(
                                        id: searchResults[index],
                                        fromPage: "search",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'Tidak ada hasil ditemukan',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
