import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();

    // return BlocConsumer<FriendoCubit, FriendoStates>(
    //   listener: (context, state) {
    //     if (state is UpdateUserDataSuccessState) {
    //       UIWidgets.showCustomToast(
    //         message: "Profile updated successfully",
    //         state: ToastStates.SUCCESS,
    //       );
    //       Navigator.pop(context);
    //     }
    //   },
    //   builder: (context, state) {
    //     FriendoCubit friendoCubit = FriendoCubit.getFriendoCubit(context);
    //     nameController.text = currentUserModel.username!;
    //     bioController.text = currentUserModel.bio!;
    //     phoneController.text = currentUserModel.phone!;

    //     return Scaffold(
    //       appBar: UIWidgets.customAppBar(
    //         context: context,
    //         title: "Edit Profile",
    //       ),
    //       body: SingleChildScrollView(
    //         child: ListView(
    //           shrinkWrap: true,
    //           children: [
    //             if (state is UploadImageLoadingState)
    //               const Padding(
    //                 padding: EdgeInsets.only(
    //                   bottom: 10.0,
    //                 ),
    //                 child: LinearProgressIndicator(),
    //               ),

    //             // Cover + profile image
    //             SizedBox(
    //               height: 240,
    //               child: Stack(
    //                 children: [
    //                   // Cover image + cover camera icon
    //                   Stack(
    //                     alignment: Alignment.bottomRight,
    //                     children: [
    //                       // Cover
    //                       SizedBox(
    //                         width: double.infinity,
    //                         height: 190,
    //                         child: CachedNetworkImage(
    //                           imageUrl: currentUserModel.coverImage!,
    //                           imageBuilder: (context, imageProvider) {
    //                             return Container(
    //                               decoration: BoxDecoration(
    //                                 borderRadius: const BorderRadius.only(
    //                                   bottomLeft: Radius.circular(5.0),
    //                                   bottomRight: Radius.circular(5.0),
    //                                 ),
    //                                 image: DecorationImage(
    //                                   image: NetworkImage(
    //                                     currentUserModel.coverImage!,
    //                                   ),
    //                                   fit: BoxFit.cover,
    //                                 ),
    //                               ),
    //                             );
    //                           },
    //                           // placeholder: (context, url) {
    //                           //   return const Center(
    //                           //     child: CircularProgressIndicator(),
    //                           //   );
    //                           // },
    //                         ),
    //                       ),

    //                       // Cover camera icon
    //                       Positioned(
    //                         bottom: 0.0,
    //                         right: 0.0,
    //                         child: TextButton(
    //                           onPressed: () {
    //                             UIWidgets.showImageDialog(
    //                               galleryOnPressed: () {
    //                                 friendoCubit.uploadImage();
    //                                 Navigator.pop(context);
    //                               },
    //                               cameraOnPressed: () {
    //                                 friendoCubit.uploadImage(
    //                                   fromGallery: false,
    //                                 );
    //                                 Navigator.pop(context);
    //                               },
    //                               context: context,
    //                             );
    //                           },
    //                           child: CircleAvatar(
    //                             radius: 20,
    //                             backgroundColor: Colors.grey.withAlpha(150),
    //                             child: const Icon(
    //                               Icons.camera_alt_outlined,
    //                               color: Colors.black,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),

    //                   // Profile image + profile camera icon
    //                   Align(
    //                     alignment: Alignment.bottomCenter,
    //                     child: Stack(
    //                       alignment: Alignment.bottomRight,
    //                       children: [
    //                         // Profile image
    //                         CircleAvatar(
    //                           radius: 64,
    //                           backgroundColor:
    //                               Theme.of(context).scaffoldBackgroundColor,
    //                           child: CachedNetworkImage(
    //                             imageUrl: currentUserModel.profileImage!,
    //                             imageBuilder: (context, imageProvider) {
    //                               return CircleAvatar(
    //                                 radius: 60,
    //                                 backgroundImage: NetworkImage(
    //                                   currentUserModel.profileImage!,
    //                                 ),
    //                                 backgroundColor: Colors.grey.withAlpha(150),
    //                               );
    //                             },
    //                             placeholder: (context, url) {
    //                               return const Center(
    //                                 child: CircularProgressIndicator(),
    //                               );
    //                             },
    //                           ),
    //                         ),

    //                         // Profile camera icon
    //                         TextButton(
    //                           onPressed: () {
    //                             UIWidgets.showImageDialog(
    //                               galleryOnPressed: () {
    //                                 friendoCubit.uploadImage(
    //                                   isProfile: true,
    //                                   fromGallery: true,
    //                                 );
    //                                 Navigator.pop(context);
    //                               },
    //                               cameraOnPressed: () {
    //                                 friendoCubit.uploadImage(
    //                                   isProfile: true,
    //                                   fromGallery: false,
    //                                 );
    //                                 Navigator.pop(context);
    //                               },
    //                               context: context,
    //                             );
    //                           },
    //                           child: const CircleAvatar(
    //                             radius: 20,
    //                             backgroundColor: Colors.grey,
    //                             child: Icon(
    //                               Icons.camera_alt_outlined,
    //                               color: Colors.black,
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),

    //             // Edit name, bio, and phone number
    //             Padding(
    //               padding: const EdgeInsets.all(10.0),
    //               child: Column(
    //                 children: [
    //                   // Edit name
    //                   UIWidgets.customTextFormField(
    //                     textController: nameController,
    //                     keyboardType: TextInputType.name,
    //                     prefixIcon: const Icon(
    //                       Icons.person,
    //                     ),
    //                     label: "Name",
    //                     validator: (name) {
    //                       if (name!.isEmpty) {
    //                         return "Name must not be empty";
    //                       }
    //                       return null;
    //                     },
    //                     context: context,
    //                   ),

    //                   // Edit bio
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(
    //                       vertical: 20.0,
    //                     ),
    //                     child: UIWidgets.customTextFormField(
    //                       textController: bioController,
    //                       keyboardType: TextInputType.text,
    //                       prefixIcon: const Icon(
    //                         Icons.info_outline_rounded,
    //                       ),
    //                       label: "Bio",
    //                       validator: (name) {
    //                         return null;
    //                       },
    //                       context: context,
    //                     ),
    //                   ),

    //                   // Edit phone number
    //                   UIWidgets.customTextFormField(
    //                     textController: phoneController,
    //                     keyboardType: TextInputType.phone,
    //                     prefixIcon: const Icon(
    //                       Icons.phone,
    //                     ),
    //                     label: "Phone",
    //                     validator: (name) {
    //                       if (name!.isEmpty) {
    //                         return "Phone number must not be empty";
    //                       }
    //                       return null;
    //                     },
    //                     context: context,
    //                   ),

    //                   UIWidgets.vSeparator(),

    //                   // Update button
    //                   Row(
    //                     children: [
    //                       Expanded(
    //                         child: UIWidgets.customMaterialButton(
    //                           onPressed: () {
    //                             friendoCubit.updateUserData(
    //                               username: nameController.text,
    //                               bio: bioController.text,
    //                               phone: phoneController.text,
    //                             );
    //                           },
    //                           text: "UPDATE",
    //                           context: context,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
