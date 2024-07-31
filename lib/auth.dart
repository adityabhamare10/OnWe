import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_project1/home.dart';
import 'shared_pref_util.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('https://display-performing-screenshots-caps.trycloudflare.com/mobile_signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print("Response Received: "+response.body);
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final String token = responseBody['token'];

      await SharedPreferencesUtil.saveToken(token);
      String? storedToken = await SharedPreferencesUtil.getToken();
      print('Stored Token Retrieved: $storedToken');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful!')));

      // Navigate to another screen if needed
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${response.reasonPhrase}')));
      print(response.reasonPhrase);
    }
  }

  Future<void> _updateToken() async {
    final String newToken = 'your_new_token';
    await SharedPreferencesUtil.updateToken(newToken);
    print('Token updated to: $newToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Go to Home Screen'),
            ),
            ElevatedButton(
              onPressed: _updateToken,
              child: Text('Update Token'),
            ),
          ],
        ),
      ),
    );
  }
}
