import 'package:chatter_box/core/consts/validtion_consts.dart';
import 'package:chatter_box/core/routing/routes.dart';
import 'package:chatter_box/features/auth/logic/cubit/auth_cubit.dart';
import 'package:chatter_box/features/auth/presention/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formLoginKey = GlobalKey();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Login Successful!")));
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
          _buildLoginForm(),
          _buildLoginButton(context),
          _buildSignUpText(context),
        ],
      ),
    ));
  }

  _headerText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi ,Welcome Back!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          'Hello again, You have been missed',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        )
      ],
    );
  }

  _buildLoginForm() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 80),
      child: Form(
        key: _formLoginKey,
        child: Column(
          children: [
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

  _buildLoginButton(context) {
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
              if (_formLoginKey.currentState!.validate()) {
                context
                    .read<AuthCubit>()
                    .login(emailController.text, passwordController.text);
              }
            },
            color: Colors.blue,
            child: Text(
              'login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  _buildSignUpText(context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Don`t have an account ?'),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.registerScreen);
            },
            child: Text(
              'signup',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
