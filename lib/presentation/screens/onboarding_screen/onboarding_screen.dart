import 'package:chatting/presentation/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "Get closer to \nEveryOne",
                    style: TextStyle(
                        fontSize: 36,
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Helps you to contact everyone with \njust easy way",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Poppins"),
                ),
              ],
            ),
            Image.asset("assets/images/splash_image.png"),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: mainButtonColor),
              child: TextButton(
                onPressed: () {
                  context.go('/auth');
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "Poppins", fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
