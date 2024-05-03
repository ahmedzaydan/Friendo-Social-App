import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/home_layout.dart';
import 'package:friendo/modules/authentication/cubit/auth_cubit.dart';
import 'package:friendo/modules/authentication/register_screen.dart';
import 'package:friendo/shared/network/local/cache_controller.dart';

import '../../shared/components/constants.dart';
import '../../shared/components/ui_widgets.dart';
import 'cubit/auth_states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BuildContext buildContext = context;
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          UIWidgets.showCustomToast(
            message: state.error,
            state: ToastStates.ERROR,
          );
        }
        if (state is LoginSuccessState) {
          // Save login data
          CacheController.saveData(
            key: 'uid',
            value: state.uid,
          );

          // Then navigate to home screen
          UIWidgets.navigateTo(
            context: context,
            pushAndFinish: true,
            destination: const HomeLayoutScreen(),
          );
        }
      },
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.getAuthCubit(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          body: Center(
            // SingleChildScrollView used to handle overflow
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Welcome to my simple login screen",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      UIWidgets.vSeparator(),

                      // Email
                      UIWidgets.customTextFormField(
                        context: buildContext,
                        textController: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.mail_rounded,
                        ),
                        label: "Enter email address please!",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email should not be empty";
                          }
                          return null;
                        },
                      ),

                      UIWidgets.vSeparator(),

                      // Password
                      UIWidgets.customTextFormField(
                        context: buildContext,
                        textController: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: authCubit.isPassword,
                        maxLines: 1,
                        prefixIcon: const Icon(
                          Icons.lock_open,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            authCubit.changePasswordVisibility();
                          },
                          icon: authCubit.passwordSuffix,
                        ),
                        label: "Enter password please!",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password must not be empty";
                          }
                          return null;
                        },
                      ),

                      UIWidgets.vSeparator(),

                      // Login + Sign up
                      state is LoginLoadingState
                          ? const CircularProgressIndicator()
                          : Row(
                              children: [
                                // Login
                                Expanded(
                                  child: UIWidgets.customMaterialButton(
                                    context: context,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        // authCubit.checkPassword(
                                        //   password: passwordController.text,
                                        // );
                                        authCubit.login(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          context: context,
                                        );
                                      }
                                    },
                                    text: "Login",
                                  ),
                                ),
                                UIWidgets.hSeparator(),

                                // Sign up
                                Expanded(
                                  child: UIWidgets.customMaterialButton(
                                    context: context,
                                    onPressed: () {
                                      UIWidgets.navigateTo(
                                          context: context,
                                          destination: RegisterScreen());
                                    },
                                    text: "Sign up",
                                  ),
                                ),
                              ],
                            ),
                      UIWidgets.vSeparator(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
