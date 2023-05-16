import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chat")
                .orderBy(
                  "createdAt",
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No messages found"),
                );
              }

              if (chatSnapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong..."),
                );
              }

              final loadedMessages = chatSnapshot.data!.docs;

              return ListView.builder(
                  reverse: true,
                  itemCount: loadedMessages.length,
                  itemBuilder: (context, index) {
                    final chatMessage = loadedMessages[index].data();
                    return MessageBubble(
                      chatMessage["text"],
                      chatMessage["username"],
                      chatMessage["userImage"],
                      chatMessage["userId"] == futureSnapshot.data!.uid,
                      key: ValueKey(loadedMessages[index].id),
                    );
                  });
            });
      },
    );
  }
}
