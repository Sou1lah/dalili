import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../api.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../widgets.dart';

class AskScreen extends StatefulWidget {
  const AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final _api = DaliliApi();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(_ChatMessage(text: 'assistantWelcome'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send([String? suggestion]) async {
    final question = (suggestion ?? _controller.text).trim();
    if (question.isEmpty || _isTyping) return;

    final languageCode = context.read<DaliliAppState>().languageCode;
    _controller.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _messages.add(_ChatMessage(question: question));
      _isTyping = true;
    });
    _scrollToEnd();

    final answer = await _api.ask(question, languageCode);
    if (!mounted) return;
    setState(() {
      _messages.add(_ChatMessage(answer: answer));
      _isTyping = false;
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 10),
          child: ScreenHeading(
            title: tr(context, 'askTitle'),
            subtitle: tr(context, 'tagline'),
          ),
        ),
        if (_messages.length == 1)
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                for (final procedure in procedures.take(3))
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ActionChip(
                      label: Text(tr(context, procedure.titleKey)),
                      onPressed: () => _send(tr(context, procedure.titleKey)),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return _TypingIndicator(label: tr(context, 'thinking'));
              }
              return _MessageBubble(message: _messages[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: tr(context, 'askHint'),
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      12,
                      8,
                      12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: tr(context, 'send'),
                onPressed: _isTyping ? null : _send,
                icon: const DirectionalIcon(Icons.send_rounded, size: 20),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ChatMessage {
  const _ChatMessage({this.question, this.answer, this.text});

  final String? question;
  final Answer? answer;
  final String? text;

  bool get isQuestion => question != null;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isQuestion = message.isQuestion;
    final alignment = isQuestion
        ? AlignmentDirectional.centerEnd
        : AlignmentDirectional.centerStart;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.86,
        ),
        margin: const EdgeInsetsDirectional.only(bottom: 10),
        padding: const EdgeInsetsDirectional.all(14),
        decoration: BoxDecoration(
          color: isQuestion ? colors.primary : colors.surface,
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(20),
            topEnd: const Radius.circular(20),
            bottomStart: Radius.circular(isQuestion ? 20 : 5),
            bottomEnd: Radius.circular(isQuestion ? 5 : 20),
          ),
          border: isQuestion ? null : Border.all(color: colors.outlineVariant),
        ),
        child: isQuestion
            ? Text(message.question!, style: TextStyle(color: colors.onPrimary))
            : _AssistantContent(message: message),
      ),
    );
  }
}

class _AssistantContent extends StatelessWidget {
  const _AssistantContent({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final answer = message.answer;
    if (answer == null)
      return Text(tr(context, message.text ?? 'assistantWelcome'));

    if (!answer.found) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(context, 'notFoundTitle'),
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(tr(context, 'notFoundBody')),
          const SizedBox(height: 8),
          Chip(
            avatar: const Icon(Icons.search_off_rounded, size: 18),
            label: Text(tr(context, 'sourceChipEmpty')),
          ),
          const SizedBox(height: 4),
          const VerificationNote(),
        ],
      );
    }

    final steps = answer.answer.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < steps.length; index++)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    steps[index].replaceFirst(RegExp(r'^\d+\.\s*'), ''),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 4),
        if (answer.sources.isNotEmpty)
          Wrap(
            spacing: 4,
            runSpacing: 2,
            children: answer.sources
                .map((source) => SourceChip(source: source))
                .toList(),
          ),
        const SizedBox(height: 4),
        const VerificationNote(),
      ],
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      margin: const EdgeInsetsDirectional.only(bottom: 10),
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadiusDirectional.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 9),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  );
}
