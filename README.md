# my_flutter_apps

나의 플러터 연습장

## 실행 방법

API 키는 컴파일 타임 define 으로 주입한다. 반드시 아래처럼 실행해야 한다.

```bash
flutter run --dart-define-from-file=.env
```

`--dart-define-from-file` 없이 그냥 `flutter run` 하면 `GEMINI_API_KEY` 가 빈 문자열이 되고,
앱이 "GEMINI_API_KEY 가 비어 있습니다" 에러 말풍선을 띄운다.

VS Code 에서 실행할 때는 실행 목록에서 `.vscode/launch.json` 의 **flutter_env** 설정을 골라야
같은 인자가 적용된다. Android Studio 의 기본 run config 에는 이 인자가 없다.

## .env 설정

`.env` 는 gitignore 대상이므로 클론 후 직접 만들어야 한다. 한 줄이면 된다.

```
GEMINI_API_KEY=<발급받은 키>
```

- 키는 <https://aistudio.google.com/apikey> 에서 발급한다.
- 2026년부터 AI Studio 가 발급하는 키는 `AQ.Ab…` 형식이다. 옛 `AIza…` 형식이 아니어도 정상이다.
- **`String.fromEnvironment` 는 컴파일 타임에 값이 박히므로, `.env` 를 고친 뒤에는
  hot reload 가 아니라 완전 재시작(앱 종료 후 다시 `flutter run`)이 필요하다.**
