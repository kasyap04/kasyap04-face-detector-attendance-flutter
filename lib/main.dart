import 'package:flutter/material.dart';
import 'package:face_attendence/view/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(titleLarge: TextStyle(color: Colors.black)),
      ),
      home: Dashboard(),
    );
  }
}
