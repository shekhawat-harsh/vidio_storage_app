import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enter_video_storage_app/location_cordinate_provider.dart';
import 'package:enter_video_storage_app/main.dart';
import 'package:enter_video_storage_app/screens/login_page.dart';
import 'package:enter_video_storage_app/screens/video_player_screen.dart';
import 'package:enter_video_storage_app/show_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController videoPlayerController;
  bool loading = false;
  File? file;
  ImagePicker imagePicker = ImagePicker();
  var fireStoreref = FirebaseFirestore.instance.collection(moNum!);
  var storeageRef = FirebaseStorage.instance
      .ref("/$moNum/${DateTime.now().microsecondsSinceEpoch}.mp4");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Your Memories ",
          style: GoogleFonts.atkinsonHyperlegible(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => const LoginPage()));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "camera",
            backgroundColor: Colors.black,
            onPressed: () async {
              setState(() {
                loading = true;
              });

              final pickedVidio =
                  await imagePicker.pickVideo(source: ImageSource.camera);
              if (pickedVidio == null) {
                SnackBar snackBar = SnackBar(
                    content: Text(
                  "video not recorded! ",
                  style: GoogleFonts.atkinsonHyperlegible(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                setState(() {
                  loading = false;
                });
              } else {
                Timer(Duration(seconds: 0), ()=> showBottomSheet(context: context, builder: (ctx) => BottolSheet()));
                var placemark = await determinePosition();
                var location =
                    "${placemark[0].street} ,${placemark[0].subLocality} ,  ${placemark[0].postalCode} , ${placemark[0].country} ";
                var video = File(pickedVidio.path);
                await storeageRef.putFile(video);
                var url = await storeageRef.getDownloadURL();
                await fireStoreref
                    .doc()
                    .set({"location": location, "video": url , "title" : title , "discription" :description});
                setState(() {
                  loading = false;
                });
              }
            },
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : Icon(
                    Icons.camera,
                    color: colorBackground,
                  ),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            heroTag: "gallary",
            backgroundColor: Colors.black,
            onPressed: () async {
              setState(() {
                loading = true;
              });

              var placemark = await determinePosition();

              var location =
                  "${placemark[0].street} ,${placemark[0].subLocality} ,  ${placemark[0].postalCode} , ${placemark[0].country} ";

              final pickedVidio =
                  await imagePicker.pickVideo(source: ImageSource.gallery);
              if (pickedVidio == null) {
                SnackBar snackBar =
                    const SnackBar(content: Text("Pick a valid Video "));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                setState(() {
                  loading = false;
                });
              } else {
                var video = File(pickedVidio.path);
                await storeageRef.putFile(video);
                var url = await storeageRef.getDownloadURL();
                await fireStoreref
                    .doc()
                    .set({"location": location, "video": url , "title" : title , "discription" :description});
                setState(() {
                  loading = false;
                });
              }
            },
            child: loading
                ? const CircularProgressIndicator()
                : Icon(
                    Icons.add,
                    color: colorBackground,
                  ),
          ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder(
              stream: fireStoreref.snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData || snapshot.data != null) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "add Memories shap shap",
                        style: GoogleFonts.atkinsonHyperlegible(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(94, 0, 0, 0)),
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => VideoPlayerScreen(
                                          videoLink: snapshot.data!.docs[index]
                                              ["video"])));
                            },
                            child: Card(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]["location"],
                                        style: GoogleFonts.atkinsonHyperlegible(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Image.asset("lib/assets/thumbnail.jpg"),
                                ],
                              ),
                            )));
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
      backgroundColor: colorBackground,
    );
  }
}



