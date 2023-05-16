import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  //var _enteredMessage = "";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final enteredMessage = _controller.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _controller.clear();
    
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": enteredMessage,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "username": userData.data()!["username"],
      "userImage": userData.data()!["image_url"],
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        // Container(
        //   margin: const EdgeInsets.only(top: 8),
        //   padding: const EdgeInsets.all(8),
        Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: "Send a message..."),
              controller: _controller,
              // onChanged: (value) {
              //   setState(() {
              //     _enteredMessage = value;
              //   });
              // },
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.send),
            onPressed:
                // _enteredMessage.trim().isEmpty ? null : _sendMessage,
                _sendMessage,
          ),
        ],
      ),
    );
  }
}
