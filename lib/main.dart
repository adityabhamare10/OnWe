import 'package:flutter/material.dart';
import 'package:flutter_project1/home.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   Future<void> _login() async {
//     final String username = _usernameController.text;
//     final String password = _passwordController.text;
//
//     final response = await http.post(
//       Uri.parse('https://xdt1k66uezwc.share.zrok.io/mobileLogin'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'username': username,
//         'password': password,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = jsonDecode(response.body);
//       final String token = responseBody['token'];
//       print('Token: $token');
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', token);
//
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful!')));
//
//       // Navigate to another screen if needed
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${response.reasonPhrase}')));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _login,
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Text('Welcome to the Home Screen!'),
//       ),
//     );
//   }
// }
