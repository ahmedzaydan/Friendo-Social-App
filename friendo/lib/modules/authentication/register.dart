import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/shared/components/classes/custom_button.dart';
import 'package:friendo/shared/components/classes/custom_toast.dart';

import '../../shared/components/classes/custom_text_form_field.dart';
import '../../shared/components/custom_utilities.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/color.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_states.dart';
import 'login.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BuildContext buildContext = context;
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is RegisterErrorState) {
            CustomToast.showToast(
              message: state.error,
              state: ToastStates.ERROR,
            );
          }
          if (state is CreateUserSuccessState) {
            // Then navigate to login screen
            CustomUtilities.navigateTo(
              context: context,
              destination: LoginScreen(),
            );
          }
        },
        builder: (context, state) {
          AuthCubit authCubit = AuthCubit.getAuthCubit(context);
          return Scaffold(
            appBar: AppBar(),
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
                                    "Register now and socialize with others",
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

                        // Username
                        CustomTextFormField.textFormField(
                          context: buildContext,
                          textController: usernameController,
                          keyboardType: TextInputType.text,
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                          label: "Enter username please!",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username should not be empty";
                            }
                            return null;
                          },
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

                        // Phone
                        CustomTextFormField.textFormField(
                          context: buildContext,
                          textController: phoneController,
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(
                            Icons.phone,
                          ),
                          label: "Enter phone number please!",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Phone number must not be empty";
                            }
                            return null;
                          },
                        ),
                        CustomUtilities.vSeparator(),

                        // Sign up
                        state is RegisterLoadingState
                            ? const CircularProgressIndicator()
                            : CustomButton.button(
                                context: context,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    // authCubit.checkPassword(
                                    //   password: passwordController.text,
                                    // );
                                    authCubit.register(
                                      username: usernameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                },
                                text: "Sign up",
                                textColor: Colors.white,
                                backgroundColor: defaultColor,
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
