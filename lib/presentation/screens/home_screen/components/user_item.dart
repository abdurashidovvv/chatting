import 'package:chatting/domain/models/user.dart' as AppUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserItem extends StatelessWidget {
  final AppUser.User user;

  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          print("User tapped!");
          context.go(
            '/home/message',
            extra: AppUser.User(
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
                  Icon(
                    currentUserUid == user.uid
                        ? Icons.bookmark
                        : Icons.person_pin,
                    size: 50,
                    color: const Color(0xFF771F98),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    currentUserUid == user.uid
                        ? "Saved Messages"
                        : user.firstName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
