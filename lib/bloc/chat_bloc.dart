import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/ai_service.dart';
import '../data/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<SendMessage>(_onSendMessage);
    on<ClearChat>(_onClearChat);
  }

  final AiService _aiService = AiService();

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    final text = event.message.trim();
    if (text.isEmpty || state.isLoading) return;

    final updated = [
      ...state.messages,
      ChatMessage(text: text, isUser: true),
    ];
    emit(state.copyWith(messages: updated, isLoading: true));

    try {
      final reply = await _aiService.sendMessage(updated);

      emit(state.copyWith(
        messages: [...state.messages, ChatMessage(text: reply, isUser: false)],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void _onClearChat(ClearChat event, Emitter<ChatState> emit) {
    emit(const ChatState());
  }
}