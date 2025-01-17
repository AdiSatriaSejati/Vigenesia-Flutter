import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vigenesia/Models/tweet.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import 'package:vigenesia/Constant/const.dart';
import 'package:vigenesia/Models/motivasi_model.dart';

class Profile extends StatefulWidget {
  final String id;
  final String fromPage;

  const Profile({
    Key? key,
    required this.id,
    required this.fromPage,
  }) : super(key: key);
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final String baseurl = url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/cover1.jpg'),
                  ),
                ),
                child: null,
              ),
              Positioned(
                top: 10.0,
                left: 10.0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 4.65,
                ),
                child: FutureBuilder(
                  future: getDataUser(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var item = snapshot.data![0];
                      var name = item.nama;
                      var subname = name.split(' ').length > 1
                          ? name.split(' ')[1][0]
                          : null;
                      return Container(
                        margin: const EdgeInsets.only(left: 11.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: SizedBox(
                                child: CircleAvatar(
                                  radius: 19.0,
                                  child: Text(
                                    subname != null
                                        ? name.substring(0, 1) + subname
                                        : name.substring(0, 1),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19.0,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '@${item.iduser}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                const Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '·',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                const Icon(
                                  CupertinoIcons.briefcase,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  item.profesi,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Text('No Data');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
          const Divider(
            height: 10.0,
            thickness: 1.0,
          ),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 11.0),
              child: FutureBuilder(
                future: getDataMotivasiUser(widget.id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<MotivasiModel>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var item in snapshot.data!)
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Tweet(
                              id: item.id,
                              user: item.idUser,
                              text: item.isiMotivasi,
                              date: item.tanggalInput,
                              fromPage: "profile",
                            ),
                          ),
                      ],
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Text('No Data');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
