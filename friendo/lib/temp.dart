import 'package:flutter/material.dart';

class Temp extends StatelessWidget {
  const Temp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options Menu Example'),
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'option1',
                child: Text('Option 1'),
              ),
              const PopupMenuItem<String>(
                value: 'option2',
                child: Text('Option 2'),
              ),
              const PopupMenuItem<String>(
                value: 'option3',
                child: Text('Option 3'),
              ),
            ],
            onSelected: (String value) {
              // Handle the selected option
              switch (value) {
                case 'option1':
                  // Handle Option 1
                  break;
                case 'option2':
                  // Handle Option 2
                  break;
                case 'option3':
                  // Handle Option 3
                  break;
              }
            },
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: const Center(
        child: Text('Your App Content'),
      ),
      // Add the PopupMenuButton in the AppBar actions
    );
  }
}
