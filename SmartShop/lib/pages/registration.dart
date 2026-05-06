import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:smartshop/ApiURL.dart';
import 'package:smartshop/pages/home_page.dart';
import 'package:smartshop/pages/login.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController first_name = TextEditingController(); // First name
  TextEditingController last_name = TextEditingController(); // Last name
  TextEditingController email = TextEditingController(); // Email
  TextEditingController username = TextEditingController(); // Username
  TextEditingController password = TextEditingController(); // Password

  final storage = FlutterSecureStorage(); // Storing the tokens

  // All controllers

  late List<TextEditingController> all_Controllers = [];
  bool is_Password_Visible = false;

  @override
  void initState() {
    super.initState();

    all_Controllers = [first_name, last_name, email, username, password];
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
  void clearAll() {
    for (var controller in all_Controllers) {
      controller.clear();
    }
  }

  // Submission function
  void Submission() async {
    sending_to_API();
    // clearAll();
  }

  // Sending infos to an API
  Future<void> sending_to_API() async {
    // Register
    try {
      final response = await http.post(
        Uri.parse('${Apiurl.URL}${Apiurl.users_Endpoint}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "first_name": first_name.text,
          "last_name": last_name.text,
          "email": email.text,
          "username": username.text,
          "password": password.text,
        }),
      );

      if (response.statusCode == 201) {
        print("Registration successfull\n\n");

        // Get the tokens after registration
        try {
          final response = await http.post(
            Uri.parse('${Apiurl.URL}${Apiurl.access_token_Endpoint}'),
            headers: {"Content-type": "application/json"},
            body: jsonEncode({"username": username, "password": password}),
          );

          // Storing the gotten tokens
          if (response.statusCode == 201) {
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
            ); // storing the username

            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Home()),
            ); // Redirect to the home page
          } else {
            print("Erreur de connexion!!");
          }
        } catch (e) {
          print("Erreur: $e");
        }
      } else {
        print("Registration error !!!!");
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
            " Registration page",
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
              height: 620,
              width: 420,
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
                      "Register here😉",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: const Color.fromARGB(239, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 30),

                    // First name controller
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "First name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIconColor: Colors.black,
                      ),
                      onChanged: (value) => {
                        first_name.text = value,
                      }, // Saving the first_name

                      controller: first_name,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Enter first name"),
                        MinLengthValidator(
                          5,
                          errorText: "Minimum 5 caractères",
                        ),
                      ]).call,
                    ),

                    SizedBox(height: 20),

                    // last name controller
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_2_outlined),
                        hintText: "Last name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        prefixIconColor: Colors.black,
                      ),
                      controller: last_name,
                      onChanged: (value) => {
                        last_name.text = value,
                      }, // Saving the last name

                      validator: MultiValidator([
                        RequiredValidator(errorText: "Enter last name"),
                        MinLengthValidator(
                          4,
                          errorText: "Minimum 3 caracters please",
                        ),
                      ]).call,
                    ),
                    SizedBox(height: 20),

                    //  Email controller
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        prefixIconColor: Colors.black,
                      ),
                      onChanged: (value) => {
                        email.text = value,
                      }, // Saving the email
                      controller: email,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Enter your email name"),
                        EmailValidator(errorText: "Entrer un email correct"),
                      ]).call,
                    ),
                    SizedBox(height: 20),

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
                        onPressed: () {
                          Submission();
                        },
                        child: Text("Submit the infos"),
                      ),
                    ),
                    SizedBox(height: 15),

                    // If the user has already an account, redicrect him to the Log in page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account 😏?"),
                        // Button to redirect
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext contect) => Login(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(" Log in here!😎"),
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
