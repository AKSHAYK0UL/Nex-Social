import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/AuthService/FireBaseAuthFunctions.dart';
import 'package:nex_social/Screens/AuthScreens/resetPasswordScreen.dart';
import 'package:nex_social/main.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback onClick;
  SignInScreen(this.onClick);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _showpassword = true;

  Future<void> onClicksignIn() async {
    final _isValid = _formKey.currentState!.validate();
    if (!_isValid) {
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
      await Provider.of<AuthFunction>(context, listen: false)
          .signIn(_emailController.text, _passwordController.text);
      navigatorkey.currentState!.pop();
    } on FirebaseAuthException catch (error) {
      navigatorkey.currentState!.pop();
      if (error.code == 'INVALID_LOGIN_CREDENTIALS') {
        Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
            .showError('Sign In', 'Invalid email or password');
      } else if (error.code == 'invalid-email') {
        Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
            .showError('Sign In', 'Invalid email');
      } else {
        Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
            .showError('Sign In', 'Somethig went wrong');
      }
      print(error.code.toString());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                'Welcome Back!',
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
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: TextButton.icon(
                        onPressed: () async {
                          await onClicksignIn();
                        },
                        icon: Icon(
                          Icons.login,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                        label: Text(
                          'Sign In',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.onClick();
                          },
                          child: const Text(
                            'Register now',
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(resetPasswordScreen.routeName);
                          },
                          child: const Text(
                            'Forgot Password?',
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
                      ],
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
