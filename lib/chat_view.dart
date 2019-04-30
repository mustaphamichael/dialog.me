import 'package:dialog_me/bloc.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final msgCtrl = TextEditingController();
  bool isComposing = false;
  DialogBloc bloc = DialogBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dialog.me'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 2.0,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: <Widget>[
          Flexible(
              child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: StreamBuilder<List<ChatItem>>(
                      stream: bloc.chats,
                      initialData: <ChatItem>[],
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final items = snapshot.data;
                          return ListView.builder(
                              itemCount: items.length, itemBuilder: (_, index) => items[index]);
                        }
                        return Container();
                      }))),
          entry()
        ],
      ),
    );
  }

  entry() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(children: [
        Flexible(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: TextField(
            controller: msgCtrl,
            onChanged: (m) {
              isComposing = m.length > 0;
            },
            decoration: InputDecoration.collapsed(
              hintText: 'Enter a message',
            ),
          ),
        )),
        Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).accentColor),
          child: IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () {
              bloc.inputMessage.add(msgCtrl.text);
              msgCtrl.clear();
            },
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }
}

class ChatItem extends StatelessWidget {
  final String msg;
  final bool isUser;
  ChatItem({this.msg, this.isUser: false});

  List<Widget> view() {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              padding: EdgeInsets.all(10.0),
              child: Text(
                msg,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              decoration: BoxDecoration(
                  color: isUser ? Colors.green : Colors.blueAccent,
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: view(),
      ),
    );
  }
}
