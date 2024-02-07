import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/AuthService/FireBaseAuthFunctions.dart';
import 'package:nex_social/main.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onClick;
  const SignUpScreen(this.onClick);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordContoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _userNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _confirmPasswordContoller.dispose();
    super.dispose();
  }

  bool _showpassword = true;
  bool _showConfirmPassword = true;
  bool isAvaiable = false;
  Future<void> onClickSignUp() async {
    isAvaiable = Provider.of<AuthFunction>(context, listen: false)
        .checkIfUserNameExistOrNot(_userNameController.text.trim());
    final valid = _formKey.currentState!.validate();
    if (!valid || !isAvaiable) {
      return;
    }

    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      await Provider.of<AuthFunction>(context, listen: false).signUp(
        _emailController.text,
        _passwordController.text,
        _userNameController.text,
      );
      navigatorkey.currentState!.pop();
    } on FirebaseAuthException catch (error) {
      navigatorkey.currentState!.pop();
      if (error.code == 'email-already-in-use') {
        Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
            .showError('SignUp Error', 'This email is already in use');
      } else if (error.code == 'weak-password') {
        Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
            .showError('SignUp Error',
                'Password should be at least 6 characters long');
      } else if (error.code == 'invalid-email') {
        Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
            .showError('SignUp Error', 'Enter the valid email address');
      } else {
        Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
            .showError('SignUp Error', 'Something went wrong');
      }
      // print(error.code.toString());
    }
  }

  Timer? adddata;
  // void adduserInfo() {
  //   adddata = Timer.periodic(
  //     Duration(seconds: 5),
  //     (_) async {
  //       FirebaseAuth.instance.currentUser!.reload();
  //       if (FirebaseAuth.instance.currentUser!.emailVerified) {
  //         final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  //         await Provider.of<AuthFunction>(context, listen: false).storeUserInfo(
  //             _userNameController.text, _emailController.text, currentUserUid);
  //         adddata!.cancel();
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: SizedBox(
                height: 200,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child:
                      Image.asset('assets/nexsocial.jpg', fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Lets\'s create an account for you.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter user name';
                        } else if (value.isNotEmpty && !isAvaiable) {
                          return 'User name already taken';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: Theme.of(context).textTheme.titleMedium!.color,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor:
                          Theme.of(context).textTheme.titleMedium!.color,
                      cursorRadius: const Radius.circular(0),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      controller: _userNameController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).textTheme.titleMedium!.color,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor:
                          Theme.of(context).textTheme.titleMedium!.color,
                      cursorRadius: const Radius.circular(0),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      controller: _emailController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                      obscureText: _showpassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).textTheme.titleMedium!.color,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showpassword = !_showpassword;
                            });
                          },
                          icon: Icon(
                            _showpassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color:
                                Theme.of(context).textTheme.titleMedium!.color,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor:
                          Theme.of(context).textTheme.titleMedium!.color,
                      cursorRadius: const Radius.circular(0),
                      keyboardType: TextInputType.visiblePassword,
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      controller: _passwordController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty ||
                            _passwordController.text != value) {
                          return 'Invalid confirm password';
                        }
                        return null;
                      },
                      obscureText: _showConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).textTheme.titleMedium!.color,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _showConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color:
                                Theme.of(context).textTheme.titleMedium!.color,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor:
                          Theme.of(context).textTheme.titleMedium!.color,
                      cursorRadius: const Radius.circular(0),
                      keyboardType: TextInputType.visiblePassword,
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      controller: _confirmPasswordContoller,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: TextButton.icon(
                        onPressed: () async {
                          await onClickSignUp();
                        },
                        icon: Icon(
                          Icons.person,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                        label: Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          widget.onClick();
                        },
                        child: const Text(
                          'Already a member?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
