import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/services/chat/chat_service.dart';

class ChatMockService implements ChatService {
  static final List<ChatMessage> _msgs = [
    // ChatMessage(
    //   id: '1',
    //   text: 'Hello World',
    //   createdAt: DateTime.now(),
    //   userId: '123',
    //   userName: 'Roberto Bollaños',
    //   userImageUrl: 'assets/images/avatar.png',
    // ),
    // ChatMessage(
    //   id: '2',
    //   text: 'Hello',
    //   createdAt: DateTime.now(),
    //   userId: '456',
    //   userName: 'Carlos Tevez',
    //   userImageUrl: 'assets/images/avatar.png',
    // ),
    // ChatMessage(
    //   id: '1',
    //   text: 'WTF',
    //   createdAt: DateTime.now(),
    //   userId: '123',
    //   userName: 'Roberto Bollaños',
    //   userImageUrl: 'assets/images/avatar.png',
    // ),
  ];
  static MultiStreamController<List<ChatMessage>>? _controller;

  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    controller.add(_msgs);
  });

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return _msgsStream;
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final newMessage = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl,
    );
    _msgs.add(newMessage);
    _controller?.add(_msgs.reversed.toList());
    return newMessage;
  }
}
