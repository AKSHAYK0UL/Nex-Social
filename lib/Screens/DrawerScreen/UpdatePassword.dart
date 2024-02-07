import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_social/AuthService/FireBaseAuthFunctions.dart';
import 'package:provider/provider.dart';

class UpdatePassword extends StatefulWidget {
  static const routeName = 'UpdatePassword';
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final _formkey = GlobalKey<FormState>();
  bool _wrongPassword = false;
  bool _eye = true;
  bool _newPasswordEye = true;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  Future<void> updatePassword() async {
    final valid = _formkey.currentState!.validate();
    if (!valid) {
      return;
    }
    try {
      await Provider.of<AuthFunction>(context, listen: false).updatePassword(
          _currentPasswordController.text, _newPasswordController.text);
    } catch (_) {
      setState(() {
        _wrongPassword = true;
      });
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQ = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Update Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: WidgetsBinding.instance.window.viewInsets.bottom > 0
                      ? _mediaQ.height * 0.350
                      : _mediaQ.height * 0.460,
                  width: double.infinity,
                  child: Lottie.asset(
                    'assets/updatename.json',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Invalid Password';
                    }
                    return null;
                  },
                  obscureText: _eye,
                  decoration: InputDecoration(
                    hintText: 'Current Password',
                    hintStyle: Theme.of(context).textTheme.titleMedium,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _eye = !_eye;
                        });
                      },
                      icon: _eye
                          ? const Icon(Icons.visibility_off,
                              color: Colors.black)
                          : const Icon(
                              Icons.visibility,
                              color: Colors.black,
                            ),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
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
                  cursorColor: Theme.of(context).textTheme.titleMedium!.color,
                  cursorRadius: const Radius.circular(0),
                  keyboardType: TextInputType.visiblePassword,
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  controller: _currentPasswordController,
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Visibility(
                        visible: _wrongPassword,
                        child: Text(
                          'Invalid Password',
                          style: TextStyle(
                              color: Colors.red.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter new Password';
                    }
                    return null;
                  },
                  obscureText: _newPasswordEye,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    hintStyle: Theme.of(context).textTheme.titleMedium,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _newPasswordEye = !_newPasswordEye;
                        });
                      },
                      icon: _newPasswordEye
                          ? const Icon(Icons.visibility_off,
                              color: Colors.black)
                          : const Icon(
                              Icons.visibility,
                              color: Colors.black,
                            ),
                    ),
                    prefixIcon: Icon(
                      Icons.key,
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
                  cursorColor: Theme.of(context).textTheme.titleMedium!.color,
                  cursorRadius: const Radius.circular(0),
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  textInputAction: TextInputAction.done,
                  controller: _newPasswordController,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await updatePassword();
                    },
                    icon: Icon(Icons.update),
                    label: Text('Update'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
