import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/service/soket_serves.dart';

import '../../../my_oreder/preasntaion/data/models/trip_response_model.dart';
import '../../data/cubit/cubit_messages/cubit.dart';
import '../../data/cubit/cubit_messages/cubit_state.dart';
import '../../data/model/messages_model.dart';

class DriverChatScreen extends StatefulWidget {
  final TripResponseModel trip;
  final TripSocketService socketService;

  const DriverChatScreen({
    super.key,
    required this.trip,
    required this.socketService,
  });

  @override
  State<DriverChatScreen> createState() => _DriverChatScreenState();
}

class _DriverChatScreenState extends State<DriverChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_UiChatMessage> _messages = [];

  bool _isLoading = true;

  String get _tripId => widget.trip.data.id.toString();

  String get _customerAuthUser =>
      widget.trip.data.client?.authUser?.toString() ?? '';

  String get _chatTitle {
    final firstName = widget.trip.data.client?.firstName.trim() ?? '';
    final lastName = widget.trip.data.client?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? 'Chat' : fullName;
  }

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initChat() async {

    if (!mounted) return;

    widget.socketService.joinTrip(_tripId);
    _listenSocket();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (_customerAuthUser.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      // The cubit should fetch the messages and emit ChatLoaded.
      context.read<ChatCubit>().fetchMessages(_customerAuthUser);
    } catch (e) {
      debugPrint('❌ LOAD ERROR => $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _listenSocket() {
    widget.socketService.listenToNewMessages((rawData) {
      try {
        final Map<String, dynamic> actualData =
        (rawData is Map && rawData.containsKey('data'))
            ? Map<String, dynamic>.from(rawData['data'] as Map)
            : Map<String, dynamic>.from(rawData as Map);

        final incoming = ChatMessageModel.fromJson(actualData);

        if (!mounted) return;

        final converted = _UiChatMessage.fromModel(
          incoming,
          myUserId: widget.trip.data.driver!.authUser ?? '',
        );

        setState(() {
          // Replace a temporary local copy if it looks like the same message.
          final tempIndex = _messages.lastIndexWhere(
                (m) =>
            m.isTemporary &&
                m.isMe == converted.isMe &&
                m.text.trim() == converted.text.trim() &&
                converted.timestamp.difference(m.timestamp).inSeconds.abs() <= 10,
          );

          if (tempIndex != -1) {
            _messages[tempIndex] = converted.copyWith(isTemporary: false);
          } else {
            final alreadyExists = _messages.any((m) =>
            m.text.trim() == converted.text.trim() &&
                m.timestamp.difference(converted.timestamp).inSeconds.abs() <=
                    1 &&
                m.isMe == converted.isMe);

            if (!alreadyExists) {
              _messages.add(converted);
            }
          }
        });

        _scrollToBottom();
      } catch (e) {
        debugPrint('❌ SOCKET PARSE ERROR => $e');
      }
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final myId = widget.trip.data.driver!.authUser ?? '';

    final temp = _UiChatMessage(
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
      seen: false,
      senderId: myId,
      isTemporary: true,
    );

    setState(() {
      _messages.add(temp);
    });
    _controller.clear();
    _scrollToBottom();

    // Keep your existing cubit flow for the actual API call.
    context.read<ChatCubit>().sendMessage(
      authUser: _customerAuthUser,
      message: text,
      senderId: myId,
      tripId: _tripId,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatTime(DateTime dt) {
    return DateFormat('hh:mm a').format(dt);
  }

  void _syncFromCubitState(ChatState state) {
    if (state is ChatLoading) {
      if (mounted) setState(() => _isLoading = true);
      return;
    }

    if (state is ChatLoaded) {
      final myId = widget.trip.data.driver!.authUser ?? '';
      final converted = state.messages
          .map((m) => _UiChatMessage.fromModel(m, myUserId: myId))
          .toList();

      if (mounted) {
        setState(() {
          _messages
            ..clear()
            ..addAll(_mergeAndSort(converted));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }

    if (state is! ChatLoading && mounted) {
      setState(() => _isLoading = false);
    }
  }

  List<_UiChatMessage> _mergeAndSort(List<_UiChatMessage> items) {
    final merged = <_UiChatMessage>[];

    for (final item in items) {
      final exists = merged.any((m) =>
      m.text.trim() == item.text.trim() &&
          m.isMe == item.isMe &&
          m.timestamp.difference(item.timestamp).inSeconds.abs() <= 1);

      if (!exists) merged.add(item);
    }

    merged.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return merged;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) => _syncFromCubitState(state),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.main1,
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 90,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            _chatTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.08,
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 280,
                  color: AppColors.main1,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _messages.isEmpty
                      ? const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: _messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildTimeHeader();
                      }
                      return _buildBubble(
                        _messages[index - 1],
                      );
                    },
                  ),
                ),
                _buildInput(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeHeader() {
    final formattedTime = DateFormat('hh : mm a').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const Text(
            'اليوم',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formattedTime,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(_UiChatMessage msg) {
    final isMine = msg.isMe;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.main1 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.main1,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.main1,
              offset: const Offset(0, 1.5),
              blurRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 5),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: isMine ? Colors.white : Colors.black87,
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(msg.timestamp),
                  style: TextStyle(
                    color: isMine ? Colors.white70 : Colors.black45,
                    fontSize: 11,
                  ),
                ),
                if (msg.isTemporary) ...[
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.6,
                      color: isMine ? Colors.white70 : AppColors.main1,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.main1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالة...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                final isSending = state is ChatSending;

                return IconButton(
                  onPressed: isSending ? null : _sendMessage,
                  icon: isSending
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.send_outlined, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _UiChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final bool seen;
  final String? senderId;
  final bool isTemporary;

  const _UiChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.seen,
    this.senderId,
    this.isTemporary = false,
  });

  factory _UiChatMessage.fromModel(
      ChatMessageModel model, {
        required String myUserId,
      }) {
    return _UiChatMessage(
      text: model.message,
      isMe: model.senderId == myUserId,
      timestamp: model.createdAt ?? DateTime.now(),
      seen: model.seen,
      senderId: model.senderId,
      isTemporary: false,
    );
  }

  _UiChatMessage copyWith({
    String? text,
    bool? isMe,
    DateTime? timestamp,
    bool? seen,
    String? senderId,
    bool? isTemporary,
  }) {
    return _UiChatMessage(
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      timestamp: timestamp ?? this.timestamp,
      seen: seen ?? this.seen,
      senderId: senderId ?? this.senderId,
      isTemporary: isTemporary ?? this.isTemporary,
    );
  }
}