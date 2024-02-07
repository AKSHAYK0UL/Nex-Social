import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/main.dart';

class UserModel {
  final String userName;
  final String userEmail;
  final DateTime account_creates_data;
  final String uid;
  final String userNodeId;
  UserModel({
    required this.userName,
    required this.userEmail,
    required this.uid,
    required this.userNodeId,
    required this.account_creates_data,
  });
}

class AuthFunction with ChangeNotifier {
  final databaseRef = FirebaseDatabase.instance.ref();
  final List<UserModel> _userDataList = [];

  List<UserModel> get allUserData {
    return [..._userDataList];
  }

  bool checkIfUserNameExistOrNot(String username) {
    final userNameAvaiable = _userDataList
        .where((user) => user.userName.toLowerCase() == username.toLowerCase());
    return userNameAvaiable.isEmpty ? true : false;
  }

  Future<void> storeUserInfo(
      String username, String userEmail, String userUid) async {
    try {
      final userNode = databaseRef.child('UserAccountsLIST').push();
      final userKey = userNode.key;
      await userNode.set(
        {
          'Date of Register': DateTime.now().toString(),
          'User Name': username.trim(),
          'User Email': userEmail.trim(),
          'User Uid': userUid,
          'User NodeId': userKey,
        },
      );
      _userDataList.add(
        UserModel(
          userName: username,
          account_creates_data: DateTime.now(),
          userNodeId: userKey!,
          userEmail: userEmail,
          uid: userUid,
        ),
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String userName) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await FirebaseAuth.instance.currentUser!.updateDisplayName(
        userName.trim(),
      );
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> verifyUserBYEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<bool> checkEmailverificationStatus() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();

      return FirebaseAuth.instance.currentUser!.emailVerified;
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  void showError(String mode, String error) {
    showDialog(
      context: navigatorkey.currentState!.context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            '$mode Error',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '$error.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                navigatorkey.currentState!.pop();
              },
              child: Text(
                'Close',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateuserName(
      String currentPassword, String newUserName) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
      email: user!.email!,
      password: currentPassword,
    );
    return user.reauthenticateWithCredential(cred).then(
      (value) {
        showDialog(
          context: navigatorkey.currentContext!,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                'Confirm',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              content: Text('You have to LogIn again to see the changes'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    user.reauthenticateWithCredential(cred).then((value) {
                      user.updateDisplayName(newUserName);
                    }).then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      FirebaseAuth.instance.signOut();
                    });
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
      email: user!.email!,
      password: currentPassword,
    );
    return user.reauthenticateWithCredential(cred).then(
      (value) {
        showDialog(
          context: navigatorkey.currentContext!,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                'Confirm',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              content: Text('You have to LogIn again to see the changes'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    user.reauthenticateWithCredential(cred).then((value) {
                      user.updatePassword(newPassword);
                    }).then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      FirebaseAuth.instance.signOut();
                    });
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> deleteAccount(String Password) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
      email: user!.email!,
      password: Password,
    );
    return user.reauthenticateWithCredential(cred).then(
      (value) {
        showDialog(
          context: navigatorkey.currentContext!,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                'Confirm',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              content: Text('Are you sure you want to delete your account'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    user.reauthenticateWithCredential(cred).then((value) {
                      user.delete();
                    }).then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      FirebaseAuth.instance.signOut();
                    });
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
