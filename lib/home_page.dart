import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_flutter_apps/chat_item.dart';
import 'package:my_flutter_apps/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// homeViewModelProvider 에게 상태달라고 요청해서 상태 받기
    final chatList = ref.watch(homeViewModelProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      // 채팅 객체 받아오기
                      final chat = chatList[index];
                      return ChatListItem(
                        content: chat.content,
                        // 가짜 데이터 짝수면 내가 받은걸로 설정 (예시)
                        // isReceived: index.isEven,
                        isReceived: chat.isReceived,
                        isError: chat.isError,
                        isPending: chat.isPending,
                      );
                    },

                    /// 각각의 ChatListItem 간격
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  ),
                ),
                TextField(
                  controller: textController,
                  onSubmitted: (value) {
                    if (value.trim().isEmpty) {
                      return;
                    }
                    final vm = ref.read(homeViewModelProvider.notifier);
                    // 뷰모델 send 호출하고 (결과는 상태로 흘러오므로 기다리지 않는다)
                    unawaited(vm.send(value));

                    /// TextEditingController clear 메서드 이용해서
                    /// TextField 값 비워줌
                    textController.clear();
                  },
                  decoration: InputDecoration(
                    border: MaterialStateOutlineInputBorder.resolveWith(
                      (states) {
                        return OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            /// ! 붙는 이유는 BorderSide 외곽선이라 무조건 색상이 nullable 이 아니어야 되기 때문
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
      ),
    );
  }
}
