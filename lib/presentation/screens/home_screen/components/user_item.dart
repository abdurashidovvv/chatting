import 'package:chatting/domain/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserItem extends StatelessWidget {
  final User user;
  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("User tapped!");
        context.go(
          '/message',
          extra: User(
            uid: user.uid,
            firstName: user.firstName,
            lastName: user.lastName,
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF771F98), width: 2),
              borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.person_pin,
                  size: 50,
                  color: Color(0xFF771F98),
                ),
                const SizedBox(width: 20),
                Text(
                  user.firstName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
