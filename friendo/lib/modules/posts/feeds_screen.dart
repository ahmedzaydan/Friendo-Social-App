
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendo/modules/posts/cubit/post_cubit.dart';
import 'package:friendo/modules/posts/cubit/post_states.dart';
import 'package:friendo/shared/components/post_widgets.dart';

import '../../models/post_model.dart';
import '../../shared/components/ui_widgets.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var postCubit = PostCubit.getPostCubit(context);
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {
        if (state is GetPostsInfoErrorState) {
          if (kDebugMode) {
            print("error: ${state.error}");
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ConditionalBuilder(
              condition: postCubit.postModels.isNotEmpty,
              builder: (context) {
                List<PostModel> posts = postCubit.postModels.values.toList();
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostWidgets.buildPostCard(
                      context: context,
                      postModel: posts[index],
                      postModelIndex: index,
                    );
                  },
                  separatorBuilder: (context, index) => UIWidgets.vSeparator(),
                );
              },
              fallback: (context) => const Center(
                    child: CircularProgressIndicator(),
                  )),
        );
      },
    );
  }
}
