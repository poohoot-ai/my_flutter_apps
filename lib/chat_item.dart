import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    super.key,
    required this.content,
    required this.isReceived,
    this.isError = false,
    this.isPending = false,
  });

  final String content;

  final bool isReceived;

  /// 에러 말풍선이면 빨간 톤으로 보여준다
  final bool isError;

  /// 응답 기다리는 중이면 텍스트 대신 스피너를 보여준다
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: isError
              ? Colors.red[100]
              : isReceived
              ? Colors.purple[200]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: isPending
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: isError
                      ? Colors.red[900]
                      : isReceived
                      ? Colors.white
                      : Colors.black,
                ),
              ),
      ),
    );
  }
}
