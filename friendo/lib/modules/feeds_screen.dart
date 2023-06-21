import 'package:flutter/material.dart';
import 'package:friendo/shared/components/classes/custom_utilities.dart';
import 'package:friendo/shared/components/classes/post_card.dart';
import 'package:friendo/shared/components/constants.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Intro card
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5.0,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Image(
                    height: 200,
                    width: double.infinity,
                    image: NetworkImage(
                      introCardImage,
                    ),
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                      right: 10.0,
                    ),
                    child: Text(
                      "Communicate with others through friendo!",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            CustomUtilities.vSeparator(),

            // Feeds cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => PostCard.buildPostCard(
                context: context,
              ),
              separatorBuilder: (context, index) => CustomUtilities.vSeparator(
                height: 5,
              ),
              itemCount: 4,
            )
          ],
        ),
      ),
    );
  }
}
