import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/layout/home_layout.dart';
import 'package:friendo/modules/authentication/login_screen.dart';
import 'package:friendo/shared/bloc_observer.dart';
import 'package:friendo/shared/components/constants.dart';
import 'package:friendo/shared/components/ui_widgets.dart';
import 'package:friendo/shared/network/local/cache_controller.dart';
import 'package:friendo/shared/network/remote/fcm_handler.dart';
import 'package:friendo/shared/styles/themes.dart';

import 'modules/authentication/cubit/auth_cubit.dart';
import 'modules/chats/cubit/chats_cubit.dart';
import 'modules/posts/cubit/post_cubit.dart';

Future<void> firebaseMessageHandler(RemoteMessage message) async {
  if (kDebugMode) print('background message ${message.data.toString()}');
  UIWidgets.showCustomToast(
    message: 'background message',
    state: ToastStates.SUCCESS,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  FCMHandler.init();
  await Firebase.initializeApp();
  await CacheController.init();
  //1
  // var token = await FirebaseMessaging.instance.getToken();
  // if (kDebugMode) print("token: $token");

  // FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //   if (kDebugMode) (event.data.toString());
  //   UIWidgets.showCustomToast(
  //       message: 'outside the app', state: ToastStates.SUCCESS);
  // });
  // deviceToken = await FirebaseMessaging.instance.getToken() as String;
  // FirebaseMessaging.onBackgroundMessage(firebaseMessageHandler);
  // FirebaseMessaging.onMessage.listen((event) {
  //   // if (kDebugMode) print(event.data.toString());
  //   UIWidgets.showCustomToast(message: 'in app', state: ToastStates.SUCCESS);
  // });
  Widget startWidget;
  currentUId = await CacheController.getData(key: 'uid');
  currentUId == null
      ? startWidget = LoginScreen()
      : startWidget = const HomeLayoutScreen();
  runApp(FriendoApp(startWidget));
}

class FriendoApp extends StatelessWidget {
  final Widget startWidget;

  const FriendoApp(this.startWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(
          create: (context) => FriendoCubit()
            ..getUserModel(
              userId: currentUId!,
              isCurrentUser: true,
            ),
        ),
        BlocProvider(
          create: (context) => PostCubit()..getPosts(),
        ),
        BlocProvider(
          create: (context) => ChatsCubit(),
        ),
      ],
      child: SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: startWidget,
          // home:  Temp(),
          theme: lightTheme(),
        ),
      ),
    );
  }
}
