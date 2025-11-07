import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/glassmorphic_container.dart';

class ScreenC extends StatefulWidget {
  const ScreenC({super.key});

  @override
  State<ScreenC> createState() => _ScreenCState();
}

class _ScreenCState extends State<ScreenC> {
  final _phraseController = TextEditingController();
  final _hashtagsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phraseController.addListener(_updateHashtags);
  }

  @override
  void dispose() {
    _phraseController.dispose();
    _hashtagsController.dispose();
    super.dispose();
  }

  void _updateHashtags() {
    final text = _phraseController.text;
    final hashtags = _extractHashtags(text);
    if (hashtags.isNotEmpty) {
      _hashtagsController.text = hashtags.join(' ');
    }
  }

  List<String> _extractHashtags(String text) {
    final hashtags = <String>[];
    final matches = RegExp(r'#\w+').allMatches(text);
    for (final match in matches) {
      hashtags.add(match.group(0)!);
    }
    return hashtags;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final hashtags = _hashtagsController.text
          .split(' ')
          .where((tag) => tag.isNotEmpty)
          .toList();

      context.goNamed(
        'b',
        extra: {'phrase': _phraseController.text, 'hashtags': hashtags},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const GradientAppBar(title: 'Input Form'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: GlassmorphicContainer(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter your text with #hashtags',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _phraseController,
                      decoration: const InputDecoration(
                        labelText: 'Your Phrase',
                        hintText: 'Type your text with #hashtags here',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _hashtagsController,
                      decoration: const InputDecoration(
                        labelText: 'Hashtags',
                        hintText: '#hashtags will appear here',
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please include at least one hashtag';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Text('Submit', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
