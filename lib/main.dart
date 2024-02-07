import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nex_social/AuthService/FireBaseAuthFunctions.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Model/CommunityPostModel.dart';
import 'package:nex_social/Model/FilePickAndUploadFunction.dart';
import 'package:nex_social/Screens/AccessAndRequest.dart';
import 'package:nex_social/Screens/AuthScreens/resetPasswordScreen.dart';
import 'package:nex_social/Screens/CommunityScreens/AllCommunityListScreen.dart';
import 'package:nex_social/Screens/CommunityScreens/CommentScreen.dart';
import 'package:nex_social/Screens/CommunityScreens/CommunityCreaterInfo.dart';
import 'package:nex_social/Screens/CommunityScreens/CreateCommunity.dart';
import 'package:nex_social/Screens/CommunityScreens/OpenCommunityScreens.dart';
import 'package:nex_social/Screens/Drawer/AccountInfo.dart';
import 'package:nex_social/Screens/Drawer/PrivacyPolicy.dart';
import 'package:nex_social/Screens/Drawer/UpdateAccount.dart';
import 'package:nex_social/Screens/DrawerScreen/DeleteAccount.dart';
import 'package:nex_social/Screens/DrawerScreen/UpdatePassword.dart';
import 'package:nex_social/Screens/DrawerScreen/UpdateUserName.dart';
import 'package:nex_social/Screens/DrawerScreen/resetUserPassword.dart';
import 'package:nex_social/Screens/FullScreenImage.dart';
import 'package:nex_social/Screens/RequestForAccess.dart';
import 'package:nex_social/Screens/UserAccessListAndrequestList.dart';
import 'package:nex_social/Widget/AuthWidgets/ShowScreenOnUserData.dart';
import 'package:nex_social/Widget/Drawer/YourCommunities.dart';
import 'package:nex_social/Widget/drawerForUserInfo.dart';
import 'package:nex_social/firebase_options.dart';
import 'package:provider/provider.dart';

import 'Screens/ImagePreviewAndUpload.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const NexSocial());
}

final navigatorkey = GlobalKey<NavigatorState>();

class NexSocial extends StatelessWidget {
  const NexSocial({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthFunction(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommunityFunctionClass(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommunityPostFunction(),
        ),
        ChangeNotifierProvider(
          create: (context) => FilePickAndUploadFunction(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorkey,
        theme: ThemeData(
          primaryColor: Colors.blue,
          hintColor: Colors.white,
          canvasColor: Colors.grey.shade200,
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            titleSmall: TextStyle(
              color: Colors.white,
              fontSize: 18.5,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.normal,
            ),
            bodyMedium: TextStyle(
              color: Colors.blue,
              fontSize: 17,
              fontWeight: FontWeight.normal,
            ),
            bodySmall: TextStyle(
              color: Colors.blue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const ShowScreenOnUserData(),
        routes: {
          ShowScreenOnUserData.routeName: (context) =>
              const ShowScreenOnUserData(),
          AllCommunityListScreen.routeName: (context) =>
              const AllCommunityListScreen(),
          CreateCommunity.routeName: (context) => const CreateCommunity(),
          OpenCommunityScreens.routeName: (context) => OpenCommunityScreens(),
          resetPasswordScreen.routeName: (context) => resetPasswordScreen(),
          AccountInfo.routeName: (context) => AccountInfo(),
          UpdateAccount.routeName: (context) => UpdateAccount(),
          CommunityCreaterInfo.routeName: (context) => CommunityCreaterInfo(),
          UpdateUserName.routeName: (context) => const UpdateUserName(),
          UpdatePassword.routeName: (context) => const UpdatePassword(),
          ResetUserPassword.routeName: (context) => ResetUserPassword(),
          DeleteAccount.routeName: (context) => const DeleteAccount(),
          PrivacyPolicy.routeName: (context) => const PrivacyPolicy(),
          YourCommunities.routeName: (context) => const YourCommunities(),
          ImagePreviewAndUpload.routeName: (context) => ImagePreviewAndUpload(),
          FullScreenImage.routeName: (context) => const FullScreenImage(),
          drawerForUserInfo.routeName: (context) => drawerForUserInfo(),
          CommentScreen.routeName: (context) => CommentScreen(),
          AccessAndRequest.routeName: (context) => const AccessAndRequest(),
          UserAccessListAndrequestList.routeName: (context) =>
              UserAccessListAndrequestList(),
          RequestForAccess.routeName: (context) => const RequestForAccess(),
        },
      ),
    );
  }
}
