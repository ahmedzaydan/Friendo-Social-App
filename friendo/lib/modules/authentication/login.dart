// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/layout/home_layout.dart';
import 'package:friendo/modules/authentication/cubit/auth_cubit.dart';
import 'package:friendo/modules/authentication/register.dart';
import 'package:friendo/shared/components/classes/custom_toast.dart';
import 'package:friendo/shared/network/local/cache_controller.dart';

import '../../shared/components/classes/custom_button.dart';
import '../../shared/components/classes/custom_text_form_field.dart';
import '../../shared/components/custom_utilities.dart';
import '../../shared/components/constants.dart';
import 'cubit/auth_states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BuildContext buildContext = context;
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            CustomToast.showToast(
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
            CustomUtilities.navigateTo(
              context: context,
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
              child: SingleChildScrollView(
                // SingleChildScrollView used to handle overflow
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
                            height: 50,
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
                        CustomUtilities.vSeparator(),
                        // Email
                        CustomTextFormField.textFormField(
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
                        CustomUtilities.vSeparator(),
                        // Password
                        CustomTextFormField.textFormField(
                          context: buildContext,
                          textController: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          isPassword: authCubit.isPassword,
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
                        CustomUtilities.vSeparator(),

                        // Login + Sign up
                        state is LoginLoadingState
                            ? const CircularProgressIndicator()
                            : Row(
                                children: [
                                  // Login
                                  Expanded(
                                    child: CustomButton.button(
                                      context: context,
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          // authCubit.checkPassword(
                                          //   password: passwordController.text,
                                          // );
                                          authCubit.login(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                        }
                                      },
                                      text: "Login",
                                    ),
                                  ),
                                  CustomUtilities.hSeparator(),

                                  // Sign up
                                  Expanded(
                                    child: CustomButton.button(
                                      context: context,
                                      onPressed: () {
                                        CustomUtilities.navigateTo(
                                            context: context,
                                            destination: RegisterScreen());
                                      },
                                      text: "Sign up",
                                    ),
                                  ),
                                ],
                              ),
                        CustomUtilities.vSeparator(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
