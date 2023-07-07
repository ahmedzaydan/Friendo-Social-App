import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/cubit/friendo_cubit.dart';
import 'package:friendo/layout/home_layout.dart';
import 'package:friendo/modules/authentication/login_screen.dart';
import 'package:friendo/modules/posts/cubit/post_cubit.dart';
import 'package:friendo/shared/bloc_observer.dart';
import 'package:friendo/shared/components/constants.dart';
import 'package:friendo/shared/network/local/cache_controller.dart';
import 'package:friendo/shared/styles/themes.dart';
import 'package:friendo/temp.dart';

import 'modules/authentication/cubit/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await CacheController.init();

  Widget startWidget;
  currentUserId = await CacheController.getData(key: 'uid');
  currentUserId == null
      ? startWidget = LoginScreen()
      : startWidget = const HomeLayoutScreen();
  runApp(FriendoApp(startWidget));
}

class FriendoApp extends StatelessWidget {
  // const FriendoApp({super.key});
  final Widget startWidget;

  const FriendoApp(this.startWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(
            create: (context) => FriendoCubit()..getCurrentUserModel()),
        BlocProvider(create: (context) => PostCubit()..getPostsInfo()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        home: startWidget,
        theme: lightTheme(),
      ),
    );
  }
}
