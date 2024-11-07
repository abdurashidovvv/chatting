import 'package:chatting/presentation/bloc/users/user_bloc.dart';
import 'package:chatting/presentation/bloc/users/user_event.dart';
import 'package:chatting/presentation/bloc/users/user_state.dart';
import 'package:chatting/presentation/screens/home_screen/components/user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Users",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              Icons.logout,
              color: Color(0xFF771F98),
            ),
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => UserBloc()..add(FetchUsersEvent()),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserLoaded) {
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return UserItem(user: user);
                  },
                );
              } else if (state is UserError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text("No data"));
            },
          ),
        ),
      ),
    );
  }
}
