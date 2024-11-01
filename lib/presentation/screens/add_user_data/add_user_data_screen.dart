import 'package:flutter/material.dart';

class AddUserDataScreen extends StatefulWidget {
  const AddUserDataScreen({super.key});

  @override
  State<AddUserDataScreen> createState() => _AddUserDataState();
}

class _AddUserDataState extends State<AddUserDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Enter User Data Screen"),
      ),
    );
  }
}
