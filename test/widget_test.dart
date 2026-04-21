import 'package:flutter_test/flutter_test.dart';

import 'package:elevenlabs_voice_showcase/main.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    await tester.pumpWidget(const ShowcaseApp());
    await tester.pump();
    expect(find.text('ElevenLabs · Flutter'), findsOneWidget);
  });
}
