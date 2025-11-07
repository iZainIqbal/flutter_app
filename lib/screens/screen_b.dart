import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/glassmorphic_container.dart';

class ScreenB extends StatelessWidget {
  final String? phrase;
  final List<String>? hashtags;

  const ScreenB({super.key, this.phrase, this.hashtags});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasContent = phrase != null && hashtags != null;

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Display Screen',
        actions: [
          if (hasContent)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                context.goNamed('a', extra: {'congrats': true});
              },
            ),
        ],
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GlassmorphicContainer(
              child: hasContent
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Phrase:', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text.rich(
                          _buildHighlightedText(phrase!, hashtags!, theme),
                        ),
                        const SizedBox(height: 24),
                        Text('Hashtags:', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: hashtags!.map((tag) {
                            return Chip(
                              label: Text(
                                tag,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              backgroundColor: theme.colorScheme.primary,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () =>
                                context.goNamed('a', extra: {'congrats': true}),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              child: Text(
                                'Done',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'No content yet!',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.goNamed('c'),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            child: Text(
                              'Add Content',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  TextSpan _buildHighlightedText(
    String text,
    List<String> hashtags,
    ThemeData theme,
  ) {
    final spans = <TextSpan>[];
    var currentIndex = 0;

    for (final tag in hashtags) {
      final tagIndex = text.indexOf(tag, currentIndex);
      if (tagIndex == -1) continue;

      if (tagIndex > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, tagIndex)));
      }

      spans.add(
        TextSpan(
          text: tag,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      currentIndex = tagIndex + tag.length;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return TextSpan(children: spans);
  }
}
