import 'package:flutter/material.dart';
import 'package:poetry_app/pages/history/viewed_poems.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: ListView(children: [
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Today's poems"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ViewedPoems(),
              ));
            },
          )
        ]),
      ),
    );
  }
}
