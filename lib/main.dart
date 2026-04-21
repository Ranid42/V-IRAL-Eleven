import 'package:flutter/material.dart';

import 'demo_strings.dart';
import 'services/tutorial_controller.dart';
import 'theme/showcase_theme.dart';
import 'widgets/tutorial_bubble.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShowcaseApp());
}

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  int _resetEpoch = 0;

  void _toggleLanguage() {
    setState(() {
      DemoStrings.setLanguage(DemoStrings.isGerman ? 'en' : 'de');
    });
  }

  Future<void> _resetBubbles() async {
    await TutorialController.resetAll();
    if (!mounted) return;
    setState(() => _resetEpoch++);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElevenLabs voice showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: VIralColors.charcoal1,
        appBarTheme: const AppBarTheme(
          backgroundColor: VIralColors.charcoal2,
          foregroundColor: VIralColors.fg1,
          elevation: 0,
        ),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('ElevenLabs · Flutter'),
            actions: [
              TextButton(
                onPressed: _toggleLanguage,
                child: Text(
                  DemoStrings.langToggle,
                  style: const TextStyle(color: VIralColors.neon),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: DemoStrings.tutorialRestartLabel,
                onPressed: _resetBubbles,
              ),
            ],
            bottom: TabBar(
              indicatorColor: VIralColors.neon,
              labelColor: VIralColors.fg1,
              unselectedLabelColor: VIralColors.fg3,
              tabs: [
                Tab(text: DemoStrings.tabA),
                Tab(text: DemoStrings.tabB),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _DemoPage(
                key: ValueKey('a_$_resetEpoch'),
                blurb: DemoStrings.blurbA,
                stepId: DemoStrings.stepIntro,
              ),
              _DemoPage(
                key: ValueKey('b_$_resetEpoch'),
                blurb: DemoStrings.blurbB,
                stepId: DemoStrings.stepDetail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoPage extends StatelessWidget {
  final String blurb;
  final String stepId;

  const _DemoPage({
    super.key,
    required this.blurb,
    required this.stepId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              blurb,
              textAlign: TextAlign.center,
              style: VIralText.body.copyWith(color: VIralColors.fg2),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 24,
          child: TutorialBubble(
            key: ValueKey(stepId),
            stepId: stepId,
          ),
        ),
      ],
    );
  }
}
