import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

Future<void> showErrorMessage(BuildContext context, String message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Message'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFFDD0000)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFDD0000), width: 5.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
      );
    },
  );
}

Future<void> showUserInfo(BuildContext context, Map<String, String> info) async {
  // TIN
  // const List<String> keys = [
  //   'First Name',
  //   'Last Name',
  //   'Which preference do you have for the mock interview?',
  //   'Dietary restrictions'
  // ];

  // Leetcode Workshop
  const List<String> keys = [
    'First Name',
    'Last Name',
    'Student Number'
  ];

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Information'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true, // to adjust the height to content
            itemCount: keys.length,
            itemBuilder: (context, index) {
              String key = keys[index];
              String? value = info[key];
              return ListTile(
                title: Text(key),
                subtitle: Text(value != null ? value.toString() : "N/A"),
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF6BBF4E), width: 5.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
      );
    },
  );
}

Future<void> showUserDetails(
    BuildContext context, Tuple2<Map<String, String>?, String> results) async {
  if (results.item1 == null) {
    await showErrorMessage(context, results.item2);
  } else {
    await showUserInfo(context, results.item1!);
  }
}
