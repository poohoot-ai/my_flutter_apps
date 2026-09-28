import 'package:flutter/material.dart';
import 'package:my_flutter_apps/chat_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ChatListItem(
                      content: 'content',
                      isReceived: index.isEven,
                    );
                  },

                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: WidgetStateInputBorder.resolveWith(
                    (states) {
                      return OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.purple[100]!,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
