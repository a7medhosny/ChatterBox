import 'package:chatter_box/core/DI/get_it.dart';
import 'package:chatter_box/core/consts/validtion_consts.dart';
import 'package:chatter_box/core/routing/routes.dart';
import 'package:chatter_box/core/services/auth_service.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
import 'package:chatter_box/features/home/logic/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getUsersExceptCurrent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          IconButton(
            onPressed: () async {
              await getIt.get<AuthService>().logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, Routes.loginScreen);
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  _buildUI() {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      // print("State is $state");
      if (state is HomeLoaded) {
        return _buildUsersList(state.users, context);
      } else if (state is HomeError) {
        return Center(
          child: Text(state.message),
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }

  _buildUsersList(List<UserModel> users, context) {
    if (users.isEmpty) {
      return const Center(
        child: Text(
          'No Users To Talk Yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(PLACEHOLDER_PFP),
              ),
              title: Text(
                users[index].name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                context.read<HomeCubit>().createNewChat(
                    users[index].uid, getIt.get<AuthService>().user!.uid);
                Navigator.pushNamed(
                  context,
                  Routes.chatScreen,
                  arguments: users[index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
