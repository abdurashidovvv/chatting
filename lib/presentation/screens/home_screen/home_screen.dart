import 'package:chatting/domain/models/user.dart';
import 'package:chatting/presentation/screens/home_screen/components/user_item.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) => UserItem(
            user:
                User(uid: "uid", firstName: "firstName", messages: "messages")),
      ),
    );
  }
}
