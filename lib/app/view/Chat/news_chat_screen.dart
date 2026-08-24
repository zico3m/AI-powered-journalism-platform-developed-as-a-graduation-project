import 'package:flutter/material.dart';
import '../../widgets/Appare/appare.dart';
import '../../core/app_colors.dart';
import '../../models/data/services/api/news_chat_service.dart';

class NewsChatScreen extends StatefulWidget {
  const NewsChatScreen({super.key});

  @override
  State<NewsChatScreen> createState() => _NewsChatScreenState();
}

class _NewsChatScreenState extends State<NewsChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _loading = false;
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _loading = true;
      _controller.clear();
    });

    _scrollToBottom();

    try {
      final answer = await NewsChatService.ask(text);

      setState(() {
        _messages.add({'role': 'bot', 'text': answer});
        _loading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
            {'role': 'bot', 'text': 'عذراً، حدث خطأ في جلب الإجابة'});
        _loading = false;
      });
    }
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

  Widget _buildMessageBubble(Map<String, String> msg, bool isUser) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bubbleBg = isUser
        ? AppColor.primary
        : (isDark
        ? AppColor.darkCardBackground
        : AppColor.cardBackground);

    final textColor =
    isUser ? Colors.white : (isDark
        ? AppColor.darkTextPrimary
        : AppColor.textPrimary);

    final secondaryText =
    isDark ? AppColor.darkTextSecondary : AppColor.textSecondary;

    return Container(
      margin: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: isUser ? 60 : 12,
        right: isUser ? 12 : 60,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.newspaper,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bubbleBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.25 : 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: !isUser && !isDark
                    ? Border.all(color: Colors.grey.shade200)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser) ...[
                    Row(
                      children: [
                        Text(
                          'أخبار الذكاء',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColor.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'AI',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    msg['text'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.55,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'هل لديك سؤال آخر؟',
                      style: TextStyle(
                        fontSize: 13,
                        color: isUser
                            ? Colors.white.withOpacity(0.8)
                            : secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.primary,
                    AppColor.primary.withOpacity(0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColor.darkBackground : AppColor.background,
      appBar: buildAppBar(isDark),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Icon(
                      Icons.newspaper,
                      size: 50,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'مرحباً! 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'اسألني عن آخر الأخبار والأحداث',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppColor.darkTextSecondary
                          : AppColor.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'أنا هنا لمساعدتك',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColor.darkTextSecondary
                          : AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return _buildMessageBubble(msg, isUser);
              },
            ),
          ),
          if (_loading)
            Container(
              padding: const EdgeInsets.all(16),
              margin:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColor.darkCardBackground
                    : AppColor.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(AppColor.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'جاري البحث عن الإجابة...',
                    style: TextStyle(
                      color: isDark
                          ? AppColor.darkTextSecondary
                          : AppColor.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColor.darkCardBackground
                  : AppColor.cardBackground,
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? AppColor.darkTextSecondary.withOpacity(0.2)
                      : Colors.grey.shade200,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                  Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColor.darkBackground
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isDark
                            ? AppColor.darkTextSecondary.withOpacity(0.3)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: isDark
                            ? AppColor.darkTextPrimary
                            : AppColor.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'اكتب سؤالك عن الأخبار...',
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColor.darkTextSecondary
                              : AppColor.textSecondary,
                          fontSize: 15,
                        ),
                        hintTextDirection: TextDirection.rtl,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primary,
                        AppColor.primary.withOpacity(0.9),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 24),
                    onPressed: _loading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
