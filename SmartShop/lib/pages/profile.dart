import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:smartshop/ApiURL.dart';

// Pour manipuler le fichier File

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // The actual user

  // API url
  final url = '${Apiurl.URL}${Apiurl.profileUpdate_Endpoint}';
  @override
  void initState() {
    fecthUserProfile();

    super.initState();
  }

  // Choose the image

  File? image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    ); // Choose from the gallery
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path); // set the image
      });
      uploadImage(image!);
    }
  }

  final storage = FlutterSecureStorage();
  Map<String, dynamic>? user;

  // Get the user infos
  Future<void> fecthUserProfile() async {
    String? userData = await storage.read(key: "user");

    if (userData != null) {
      setState(() {
        user = jsonDecode(userData);
      });
    }
    print("The user is: $user");
  }

  // Change the image of the profile
  Future<void> uploadImage(File image) async {
    var myUrl = Uri.parse(url);

    var request = http.MultipartRequest("POST", myUrl);

    String? token = await storage.read(key: "access"); // fetch the access token
    request.headers["Authorization"] =
        "Bearer $token"; // use the token in the headers to tell you're an user

    // Add the image file
    request.files.add(await http.MultipartFile.fromPath("image", image.path));

    // Then we send
    final response = await request.send();

    print("Le status pour l'image: ${response.statusCode} et le token: $token");
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profil mis à jour")));
    } else {
      print("Erreur : ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue, // Personnalise la couleur
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Mon Profil")),
      body: Center(
        child: Column(
          children: [
            // Affichage de l'image (Locale si choisie, sinon placeholder)
            CircleAvatar(
              radius: 60,
              // Plus besoin de rajouter l'IP car ton JSON l'a déjà (vu ton print) !
              backgroundImage: user != null
                  ? NetworkImage(user!["image"])
                  : AssetImage("assets/joe.JPG") as ImageProvider,
            ),

            ElevatedButton(
              onPressed: pickImage,
              child: Text("Changer la photo"),
            ),
          ],
        ),
      ),
    );
  }
}
