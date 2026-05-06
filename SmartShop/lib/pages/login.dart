import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:smartshop/ApiURL.dart';
import 'package:smartshop/pages/home_page.dart';
import 'package:smartshop/pages/registration.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController(); // Username
  TextEditingController password = TextEditingController(); // Password

  final storage = FlutterSecureStorage(); // To store the tokens and the user id

  // All controllers

  late List<TextEditingController> all_Controllers = [];
  bool is_Password_Visible = false;

  @override
  void initState() {
    super.initState();

    all_Controllers = [username, password];
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    for (var controller in all_Controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Clear all the controllers
  Future<void> clearAll() async {
    for (var controller in all_Controllers) {
      controller.clear();
    }
  }

  // Submission function
  void Submission() async {
    get_user_token();
    // clearAll();
  }

  String? displayValue; // Variable d'état

  // Sending infos to an API
  Future<void> get_user_token() async {
    try {
      final response = await http.post(
        Uri.parse('${Apiurl.URL}${Apiurl.access_token_Endpoint}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username.text,
          "password": password.text,
        }),
      );

      if (response.statusCode == 200) {
        print("Login successfull\n\n");
        final results = jsonDecode(response.body);
        storage.write(
          key: "access",
          value: results["access"],
        ); // Storing the access token
        storage.write(
          key: "refresh",
          value: results["refresh"],
        ); // Storing the refresh token

        storage.write(
          key: "username",
          value: username.text,
        ); // Storing the username

        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Home()),
        ); // Redirect to the home page
      } else {
        print("Login error !!!!");
      }
    } catch (e) {
      print("Erreur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Center(
          child: Text(
            " Login page",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),

            Container(
              margin: EdgeInsets.all(20),
              height: 420,
              width: 410,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: const Color.fromARGB(239, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Username controller
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.insert_drive_file_outlined),
                        hintText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        prefixIconColor: Colors.black,
                      ),

                      onChanged: (value) => {
                        username.text = value,
                      }, // Saving the username

                      controller: username,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Enter your username"),
                        MinLengthValidator(
                          4,
                          errorText: "Minimum 3 caracters please",
                        ),
                      ]).call,
                    ),
                    SizedBox(height: 20),

                    // Password controller
                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: !is_Password_Visible,

                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        prefixIconColor: Colors.black,
                        suffixIcon: IconButton(
                          onPressed: () => {
                            setState(() {
                              is_Password_Visible = !is_Password_Visible;
                            }),
                          },
                          icon: Icon(
                            is_Password_Visible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      controller: password,
                      onChanged: (value) => {
                        password.text = value,
                      }, // Saving the password

                      validator: MultiValidator([
                        RequiredValidator(errorText: "Enter your password"),

                        MinLengthValidator(
                          7,
                          errorText: "Minimum 7 caracters please",
                        ),
                      ]).call,
                    ),

                    SizedBox(height: 20),
                    // Submission button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          maximumSize: Size.fromWidth(200),
                          shape: BeveledRectangleBorder(),
                        ),
                        onPressed: () async {
                          Submission();
                          // await clearAll();
                        },
                        child: Text("Submit the infos"),
                      ),
                    ),
                    SizedBox(height: 15),

                    // If the user has already an account, redicrect him to the Log in page
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have any account 😯?"),
                        // Button to redirect
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Registration(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(" Register!👈😎"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
