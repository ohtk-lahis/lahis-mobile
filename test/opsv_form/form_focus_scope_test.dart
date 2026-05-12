import 'package:flutter/material.dart' as material;
import 'package:flutter_test/flutter_test.dart';
import 'package:podd_app/opsv_form/opsv_form.dart' as opsv;
import 'package:podd_app/opsv_form/widgets/widgets.dart';

void main() {
  testWidgets(
    'IME next moves to the next visible text input and skips non-text fields',
    (tester) async {
      final form = opsv.Form.withSection(
        'form1',
        [
          opsv.Section.withQuestions(
            'section1',
            [
              opsv.Question.withFields(
                'first question',
                [opsv.TextField('first', 'first', label: 'First')],
              ),
              opsv.Question.withFields(
                'hidden question',
                [
                  opsv.TextField(
                    'hidden',
                    'hidden',
                    label: 'Hidden',
                    condition: opsv.SimpleCondition(
                      'first',
                      opsv.ConditionOperator.equal,
                      'show',
                    ),
                  ),
                ],
              ),
              opsv.Question.withFields(
                'choice question',
                [
                  opsv.SingleChoicesField(
                    'choice',
                    'choice',
                    [
                      opsv.ChoiceOption(label: 'A', value: 'a'),
                      opsv.ChoiceOption(label: 'B', value: 'b'),
                    ],
                  ),
                ],
              ),
              opsv.Question.withFields(
                'second question',
                [opsv.TextField('second', 'second', label: 'Second')],
              ),
            ],
          ),
        ],
      );
      final controller = FormTextInputFocusController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _FocusHarness(
          controller: controller,
          questions: form.currentSection.questions,
        ),
      );

      final first = form.getField('first')!;
      final second = form.getField('second')!;

      expect(find.byType(material.TextField), findsNWidgets(2));
      expect(
          controller.textInputActionFor(first), material.TextInputAction.next);
      expect(
          controller.textInputActionFor(second), material.TextInputAction.done);

      await tester.tap(find.byType(material.TextField).first);
      await tester.pump();
      expect(controller.nodeFor(first).hasFocus, isTrue);

      await tester.testTextInput.receiveAction(material.TextInputAction.next);
      await tester.pump();

      expect(controller.nodeFor(first).hasFocus, isFalse);
      expect(controller.nodeFor(second).hasFocus, isTrue);
    },
  );
}

class _FocusHarness extends material.StatelessWidget {
  final FormTextInputFocusController controller;
  final List<opsv.Question> questions;

  const _FocusHarness({
    required this.controller,
    required this.questions,
  });

  @override
  material.Widget build(material.BuildContext context) {
    controller.sync(questions);
    return material.MaterialApp(
      home: material.Scaffold(
        body: FormTextInputFocusScope(
          controller: controller,
          child: material.SingleChildScrollView(
            child: material.Column(
              children: [
                for (final question in questions)
                  FormQuestion(question: question),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
