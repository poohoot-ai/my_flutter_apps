import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// 컴파일 타임에 박히는 값이다.
/// define 이 없으면 예외 대신 빈 문자열이 되므로 아래에서 직접 걸러준다.
/// .env 를 고친 뒤에는 hot reload 가 아니라 완전 재시작이 필요하다.
const _apiKey = String.fromEnvironment('GEMINI_API_KEY');

class Chat {
  final String content;
  final bool isReceived;
  final bool isError;
  final bool isPending;

  const Chat({
    required this.content,
    required this.isReceived,
    this.isError = false,
    this.isPending = false,
  });
}

class HomeViewModel extends Notifier<List<Chat>> {
  @override
  List<Chat> build() {
    return [];
  }

  // Gemini SDK 이용할 준비
  // 키가 비었을 때는 아예 만들지 않도록 late final 로 미뤄둔다
  late final _model = GenerativeModel(
    model: 'gemini-3.5-flash-lite',
    apiKey: _apiKey,
  );

  // Gemini SDK 한테 보내는 함수
  Future<void> send(String text) async {
    state = [
      ...state,
      Chat(content: text, isReceived: false),
    ];

    // dart-define 이 빠지면 키가 빈 문자열이 되므로 먼저 걸러낸다
    if (_apiKey.isEmpty) {
      state = [
        ...state,
        const Chat(
          content: 'GEMINI_API_KEY 가 비어 있습니다.\n'
              'flutter run --dart-define-from-file=.env 로 실행해 주세요.',
          isReceived: true,
          isError: true,
        ),
      ];
      return;
    }

    // 응답 기다리는 동안 로딩 말풍선 띄우기
    state = [
      ...state,
      const Chat(content: '', isReceived: true, isPending: true),
    ];

    try {
      final result = await _model.generateContent([Content.text(text)]);
      final reply = result.text;
      _replacePending(
        reply != null
            ? Chat(content: reply, isReceived: true)
            : const Chat(
                content: '응답이 비어 있습니다. (안전 필터에 걸렸을 수 있습니다)',
                isReceived: true,
                isError: true,
              ),
      );
    } on GenerativeAIException catch (e) {
      _replacePending(
        Chat(
          content: 'Gemini 오류: ${e.message}',
          isReceived: true,
          isError: true,
        ),
      );
    } catch (e) {
      _replacePending(
        Chat(content: '알 수 없는 오류: $e', isReceived: true, isError: true),
      );
    }
  }

  /// 로딩 말풍선 자리를 실제 결과로 바꿔준다
  void _replacePending(Chat chat) {
    final next = [...state];
    final index = next.lastIndexWhere((item) => item.isPending);
    if (index == -1) {
      next.add(chat);
    } else {
      next[index] = chat;
    }
    state = next;
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, List<Chat>>(
  () => HomeViewModel(),
);
