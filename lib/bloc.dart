import 'dart:async';
import 'package:dialog_me/chat_view.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:rxdart/rxdart.dart';

class DialogBloc {
  List<ChatItem> _msgs = <ChatItem>[];
  final _chatSubject = BehaviorSubject<List<ChatItem>>();
  Stream<List<ChatItem>> get chats => _chatSubject.stream;
  final _inputCtrl = StreamController<String>();
  Sink<String> get inputMessage => _inputCtrl.sink;
  DialogBloc() {
    _inputCtrl.stream.listen(_sendMessage);
  }
  void _sendMessage(String msg) async {
    _msgs.insert(
        0,
        ChatItem(
          msg: msg,
          isUser: true,
        ));
    _chatSubject.add(_msgs);
    final auth = await AuthGoogle(fileJson: 'assets/bot_auth.json').build();
    final d = Dialogflow(authGoogle: auth, language: Language.english);
    final res = await d.detectIntent(msg);
    res.getListMessage().forEach((v) {
      switch (v.keys.first) {
        case "text":
          {
            final m = ListTextDialogflow(v).listText.first;
            final i = ChatItem(msg: m);
            _msgs.insert(0, i);
          }
      }
    });
    _chatSubject.add(_msgs);
  }

  void dispose() {
    _chatSubject.close();
    _inputCtrl.close();
  }
}
