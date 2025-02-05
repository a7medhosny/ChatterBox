import 'package:chatter_box/core/consts/validtion_consts.dart';
import 'package:chatter_box/core/routing/routes.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
import 'package:chatter_box/features/auth/logic/cubit/auth_cubit.dart';
import 'package:chatter_box/features/auth/presention/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formRegisterKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("SignUp Successful!, go to login page"),
              ),
            );
            context
                .read<AuthCubit>()
                .addUser(UserModel(uid: state.user.uid, name: nameController.text));
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: _buildUI(context),
      ),
    );
  }

  _buildUI(context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerText(),
          _buildRegisterForm(),
          _buildRegisterButton(context),
          _buildLoginText(context),
        ],
      ),
    ));
  }

  Widget _headerText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create an Account!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          'Join us today and start your journey.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  _buildRegisterForm() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 80),
      child: Form(
        key: _formRegisterKey,
        child: Column(
          children: [
            CustomFormField(
              hintText: 'User Name',
              controller: nameController,
            ),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              hintText: 'Email',
              controller: emailController,
              validationRegExp: EMAIL_VALIDATION_REGEX,
            ),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              hintText: 'Password',
              controller: passwordController,
            ),
          ],
        ),
      ),
    );
  }

  _buildRegisterButton(context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return SizedBox(
          width: double.infinity,
          height: 45,
          child: MaterialButton(
            onPressed: () {
              if (_formRegisterKey.currentState!.validate()) {
                context
                    .read<AuthCubit>()
                    .register(emailController.text, passwordController.text);
              }
            },
            color: Colors.blue,
            child: Text(
              'sign up',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  _buildLoginText(context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('have an account?'),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.loginScreen);
            },
            child: Text(
              'login',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
