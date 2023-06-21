import 'package:flutter/material.dart';
import 'package:friendo/shared/components/classes/custom_utilities.dart';
import 'package:friendo/shared/components/constants.dart';
import 'package:friendo/shared/styles/icon_broken.dart';

class PostCard {
  static Widget buildPostCard({
    required BuildContext context,
  }) {
    var txtTheme = Theme.of(context).textTheme;
    double iconSize = 20;
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Post image, author, and date
            Row(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                    profileImage,
                  ),
                ),

                CustomUtilities.hSeparator(),

                // Name and date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Row(
                      children: [
                        Text(
                          "Ahmed Zaydan",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        CustomUtilities.hSeparator(
                          width: 5.0,
                        ),
                        Icon(
                          size: iconSize,
                          Icons.check_circle,
                          color: Colors.blue,
                        ),
                      ],
                    ),

                    // Publish date
                    Text(
                      "June 15, 2023 at 11:55 am",
                    ),
                  ],
                ),
              ],
            ),

            CustomUtilities.vSeparator(),

            // Post text and tags
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Clamorously us desynchronize gracefully psittacosis we cater cyan recurring mine connoisseur mauler i bufo scut we incurable they lithograph dey marine.",
                  style: txtTheme.bodyLarge,
                ),
                CustomUtilities.vSeparator(
                  height: 5.0,
                ),
                Wrap(
                  children: [
                    Text(
                      "#software ",
                      style: txtTheme.bodyLarge!.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "#flutter_course",
                      style: txtTheme.bodyLarge!.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Post image
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image(
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(
                  postImage,
                ),
              ),
            ),

            CustomUtilities.vSeparator(),

            // Post likes, comments
            Row(
              children: [
                // Likes
                Expanded(
                  child: InkWell(
                    child: Row(
                      children: [
                        Icon(
                          size: iconSize,
                          IconBroken.Heart,
                          color: Colors.red,
                        ),
                        CustomUtilities.hSeparator(
                          width: 5.0,
                        ),
                        Text(
                          "1.5K",
                          style: txtTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                // Comments
                Expanded(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          size: iconSize,
                          IconBroken.Chat,
                          color: Colors.amber,
                        ),
                        CustomUtilities.hSeparator(
                          width: 5.0,
                        ),
                        Text(
                          "1.5K comments",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            CustomUtilities.vSeparator(),

            // Post actions
            Row(
              children: [
                // Comment
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 10.0,
                          backgroundImage: NetworkImage(
                            profileImage,
                          ),
                        ),
                        CustomUtilities.hSeparator(
                          width: 5.0,
                        ),
                        Icon(
                          IconBroken.Chat,
                          color: Colors.amber,
                          size: iconSize,
                        ),
                        CustomUtilities.hSeparator(
                          width: 5.0,
                        ),
                        Text(
                          "Write comment...",
                          style: txtTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                // Like
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: iconSize,
                        ),
                        CustomUtilities.hSeparator(
                          width: 5.0,
                        ),
                        Text(
                          "Like",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
