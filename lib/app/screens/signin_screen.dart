import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:socialseed/app/cubits/auth/auth_cubit.dart';
import 'package:socialseed/app/cubits/credential/credential_cubit.dart';
import 'package:socialseed/app/screens/home_screen.dart';
import 'package:socialseed/utils/constants/color_const.dart';
import 'package:socialseed/utils/constants/page_const.dart';
import 'package:socialseed/utils/constants/text_const.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // controllers

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // local variables
  bool isPressed = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  bool _isSigningUp = false;
  bool _isUploading = false;

  // UI Methods

  Widget getTextField(
      TextEditingController controller, String label, TextInputType key) {
    return Container(
      height: 66,
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.greyColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: key,
        validator: (value) {
          // Add your validation logic here
          if (value!.isEmpty) {
            return 'Please enter $label';
          }

          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
        ),
      ),
    );
  }

  Widget getTextFieldWithPassword(
      TextEditingController controller, String label) {
    bool isPressed = false; // Assuming you have this boolean in your class

    return Container(
      height: 66,
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.greyColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: TextFormField(
              controller: controller,
              obscureText:
                  !isPressed, // Invert the value for password visibility
              validator: (value) {
                // Add your validation logic here
                if (value!.isEmpty) {
                  return 'Please enter $label';
                }
                // You can add more complex validation rules as needed
                return null; // Return null if the input is valid
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: label,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(isPressed ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                // Toggling the visibility of the password
                setState(() {
                  isPressed = !isPressed;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _bodyWidget() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Image.asset('assets/SOCIALSEED.png'),

            // JOIN NOW
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Welcome Back',
                style: TextConst.MediumStyle(49, AppColor.blackColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Hoe've you been this days , Let's Hope on... ",
                style: TextConst.RegularStyle(15, AppColor.textGreyColor),
              ),
            ),

            sizeVar(15),

            sizeVar(15),
            // Form Fields

            getTextField(_emailController, 'Email', TextInputType.emailAddress),
            getTextFieldWithPassword(_passwordController, 'Password'),

            // dob

            // Submit Button
            GestureDetector(
              onTap: () {
                loginUser();
              },
              child: Container(
                height: 66,
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColor.redColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextConst.headingStyle(18, AppColor.whiteColor),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Text(
                    "Don't Have an Account?",
                    style: TextConst.RegularStyle(15, AppColor.textGreyColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, PageConst.registerPage, (context) => false);
                  },
                  child: Text('Create Now',
                      style: TextConst.headingStyle(15, AppColor.redColor)),
                )
              ],
            ),
            sizeVar(30),
            Center(
              child: Text(
                'Socialseed @2024 Copyright (c)',
                style: TextConst.RegularStyle(18, AppColor.blackColor),
              ),
            ),
            sizeVar(30),
          ],
        ),
      ),
    );
  }

  void loginUser() {
    BlocProvider.of<CredentialCubit>(context)
        .signInUser(
          email: _emailController.text,
          password: _passwordController.text,
        )
        .then((val) => _clear());
  }

  _clear() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, state) {
          if (state is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }

          if (state is CredentialFailure) {
            print('Invalid Details');
          }
        },
        builder: (context, state) {
          if (state is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return HomeScreen(uid: state.uid);
                } else {
                  return _bodyWidget();
                }
              },
            );
          }

          return _bodyWidget();
        },
      ),
    );
  }
}
