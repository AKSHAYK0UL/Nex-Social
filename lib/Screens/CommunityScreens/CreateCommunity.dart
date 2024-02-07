import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_social/AuthService/FireBaseAuthFunctions.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/main.dart';
import 'package:provider/provider.dart';

class CreateCommunity extends StatefulWidget {
  static const routeName = 'CreateCommunity';
  const CreateCommunity({super.key});

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

List<String> communityType = ['Private', 'Public'];

class _CreateCommunityState extends State<CreateCommunity> {
  final _communityNameController = TextEditingController();
  final _communityDespController = TextEditingController();
  bool _isAvaiable = false;
  final _formKey = GlobalKey<FormState>();
  Future<void> onClickCreateCommunity() async {
    _isAvaiable = Provider.of<CommunityFunctionClass>(context, listen: false)
        .checkIfCommunityNameIsAvaiable(_communityNameController.text.trim());
    final valid = _formKey.currentState!.validate();

    if (!valid || !_isAvaiable) {
      return;
    }

    try {
      final adminDetails = FirebaseAuth.instance.currentUser!;
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      await Provider.of<CommunityFunctionClass>(context, listen: false)
          .allCommunityNodeList(
        adminDetails.displayName!,
        _communityNameController.text.trim(),
        _communityDespController.text.trim(),
        adminDetails.uid,
        currentOption,
      );
      _communityNameController.clear();
      _communityDespController.clear();
      Future.delayed(const Duration(seconds: 3), () {
        navigatorkey.currentState!.pop();
      }).then((value) {
        Provider.of<CommunityFunctionClass>(navigatorkey.currentContext!,
                listen: false)
            .showSnackBar('Community Created');
      });
    } on FirebaseException catch (error) {
      navigatorkey.currentState!.pop();
      Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
          .showError('Unable to create', error.code);
    }
  }

  Future<void> fun() async {
    final x = FirebaseAuth.instance.currentUser!;
    await Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
        .storeUserInfo(x.displayName!, x.email!, x.uid);
  }

  @override
  void initState() {
    final x = FirebaseAuth.instance.currentUser!;
    final z = Provider.of<AuthFunction>(context, listen: false)
        .checkIfUserNameExistOrNot(x.displayName!);
    if (!z) {
      fun();
    }

    super.initState();
  }

  String currentOption = communityType[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Create Community'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              // height: 300,
              height: MediaQuery.of(context).size.height * 0.39,
              child: Lottie.asset(
                'assets/community.json',
                repeat: false,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: RadioListTile(
                            title: const Text('Private'),
                            value: communityType[0],
                            groupValue: currentOption,
                            onChanged: (value) {
                              setState(
                                () {
                                  currentOption = value.toString();
                                },
                              );
                            },
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: RadioListTile(
                            title: const Text('Public'),
                            value: communityType[1],
                            groupValue: currentOption,
                            onChanged: (value) {
                              setState(
                                () {
                                  currentOption = value.toString();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter community name';
                        } else if (value.isNotEmpty && !_isAvaiable) {
                          return 'Community name already taken';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Community name',
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        prefixIcon: Icon(
                          Icons.group,
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
                      controller: _communityNameController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter community description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Community Description',
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        prefixIcon: Icon(
                          Icons.description,
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
                      keyboardType: TextInputType.multiline,
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      controller: _communityDespController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: TextButton.icon(
                        onPressed: () async {
                          await onClickCreateCommunity();
                        },
                        icon: const Icon(
                          Icons.group,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Create Community',
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
