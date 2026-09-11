part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;

  SendMessage(this.message);
}

class ClearChat extends ChatEvent {}

class CopyResponse extends ChatEvent {
  final String response;

  CopyResponse(this.response);
}