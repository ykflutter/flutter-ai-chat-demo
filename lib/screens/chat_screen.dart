import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../data/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const _suggestions = [
    'What is the difference between StatelessWidget and StatefulWidget?',
    'How do I call an API in Bloc?',
    'When should I use ListView.builder?',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? preset]) {
    final message = (preset ?? _controller.text).trim();
    if (message.isEmpty) return;

    context.read<ChatBloc>().add(SendMessage(message));
    _controller.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Assistant'),
        actions: [
          IconButton(
            onPressed: () => context.read<ChatBloc>().add(ClearChat()),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          _scrollToBottom();

          if (state.error != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            state.messages.length + (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.messages.length) {
                            return _buildTypingBubble();
                          }
                          return _buildMessageBubble(state.messages[index]);
                        },
                      ),
              ),
              _buildInputBar(state.isLoading),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.code, size: 56, color: Colors.blue),
            const SizedBox(height: 12),
            const Text(
              'Flutter Assistant',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Ask me anything about Flutter and Dart',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _suggestions
                  .map(
                    (q) => ActionChip(
                      label: Text(q),
                      onPressed: () => _sendMessage(q),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final colors = Theme.of(context).colorScheme;
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser
              ? colors.primaryContainer
              : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isUser ? 12 : 2),
            bottomRight: Radius.circular(isUser ? 2 : 12),
          ),
        ),
        child: SelectableText(message.text),
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildInputBar(bool isLoading) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Ask a Flutter question...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: isLoading ? null : _sendMessage,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
