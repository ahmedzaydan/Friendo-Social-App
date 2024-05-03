import 'package:flutter/material.dart';

class Temp extends StatelessWidget {
  const Temp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onLongPress: () {
            // Show the options menu
            _showOptionsMenu(context);
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text(
              'Press and hold for options menu',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox? itemBox = context.findRenderObject() as RenderBox?;
    final Offset position =
        itemBox!.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          value: 'Option 1',
          child: Text('Option 1'),
        ),
        const PopupMenuItem(
          value: 'Option 2',
          child: Text('Option 2'),
        ),
        // Add more options as needed
      ],
    ).then((value) {
      if (value != null) {
        // Handle the selected option
        switch (value) {
          case 'Option 1':
            // Perform action for Option 1
            break;
          case 'Option 2':
            // Perform action for Option 2
            break;
        }
      }
    });
  }
}
