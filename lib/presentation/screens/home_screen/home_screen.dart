import 'package:chatting/domain/models/user.dart';
import 'package:chatting/presentation/bloc/users/user_bloc.dart';
import 'package:chatting/presentation/bloc/users/user_event.dart';
import 'package:chatting/presentation/bloc/users/user_state.dart';
import 'package:chatting/presentation/screens/home_screen/components/user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => UserBloc()..add(FetchUsersEvent()),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return ListTile(
                    title: Text(user.firstName),
                    subtitle: Text(user.lastName),
                  );
                },
              );
            } else if (state is UserError) {
              return Center(child: Text(state.message));
            }
            return Center(child: const Text("No data"));
          },
        ),
      ),
    );
  }
}
