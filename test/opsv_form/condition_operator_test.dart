import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_test/flutter_test.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/opsv_form/opsv_form.dart';
import 'package:podd_app/l10n/app_localizations.dart';

void main() {
  setUpAll(() {
    locator.registerSingletonAsync<AppLocalizations>(() async {
      return AppLocalizations.delegate.load(const material.Locale('en'));
    });
  });

  group("parse list-membership operators from json", () {
    test("positive aliases map to isOneOf", () {
      for (final op in ['in', 'has_one_of', 'hasOneOf', 'isOneOf']) {
        final condition = SimpleCondition.fromJson({
          "name": "category",
          "operator": op,
          "value": "A,B,C",
        });
        expect(condition.operator, ConditionOperator.isOneOf,
            reason: "operator '$op' should map to isOneOf");
      }
    });

    test("negative aliases map to isNotOneOf", () {
      for (final op in ['not_in', 'notIn', 'isNotOneOf', 'is_not_one_of']) {
        final condition = SimpleCondition.fromJson({
          "name": "category",
          "operator": op,
          "value": "A,B,C",
        });
        expect(condition.operator, ConditionOperator.isNotOneOf,
            reason: "operator '$op' should map to isNotOneOf");
      }
    });
  });

  group("evaluate via JSON-parsed 'in' / 'not_in' operators", () {
    SimpleCondition parsed(String operator, String value) {
      return SimpleCondition.fromJson({
        "name": "category",
        "operator": operator,
        "value": value,
      });
    }

    test("TextField membership and exclusion", () {
      final field = TextField("id1", "category");
      field.value = "B";

      final inCondition = parsed("in", "A,B,C");
      expect(inCondition.operator, ConditionOperator.isOneOf);
      expect(field.evaluate(inCondition.operator, inCondition.value), isTrue);

      final notInCondition = parsed("not_in", "A,B,C");
      expect(notInCondition.operator, ConditionOperator.isNotOneOf);
      expect(
          field.evaluate(notInCondition.operator, notInCondition.value),
          isFalse);

      field.value = "D";
      expect(field.evaluate(inCondition.operator, inCondition.value), isFalse);
      expect(
          field.evaluate(notInCondition.operator, notInCondition.value), isTrue);
    });

    test("TextField trims spaces in list tokens", () {
      final field = TextField("id1", "category");
      field.value = "B";
      final condition = parsed("in", "A, B, C");
      expect(field.evaluate(condition.operator, condition.value), isTrue);
    });

    test("IntegerField membership and exclusion", () {
      final field = IntegerField("id1", "age");
      field.value = 25;

      final inCondition = parsed("in", "18,25,30");
      expect(field.evaluate(inCondition.operator, inCondition.value), isTrue);

      final notInCondition = parsed("not_in", "18,25,30");
      expect(
          field.evaluate(notInCondition.operator, notInCondition.value),
          isFalse);

      field.value = 26;
      expect(field.evaluate(inCondition.operator, inCondition.value), isFalse);
      expect(
          field.evaluate(notInCondition.operator, notInCondition.value), isTrue);
    });

    test("SingleChoicesField membership and exclusion", () {
      final field = SingleChoicesField(
        "id1",
        "color",
        [
          ChoiceOption(label: "Red", value: "red"),
          ChoiceOption(label: "Blue", value: "blue"),
          ChoiceOption(label: "Green", value: "green"),
        ],
      );
      field.value = "blue";

      final inCondition = parsed("in", "red,blue");
      expect(field.evaluate(inCondition.operator, inCondition.value), isTrue);

      final notInCondition = parsed("not_in", "red,blue");
      expect(
          field.evaluate(notInCondition.operator, notInCondition.value),
          isFalse);

      field.value = "green";
      expect(field.evaluate(inCondition.operator, inCondition.value), isFalse);
      expect(
          field.evaluate(notInCondition.operator, notInCondition.value), isTrue);
    });

    test("DecimalField membership", () {
      final field = DecimalField("id1", "price");
      field.value = Decimal.parse("10.5");
      final condition = parsed("in", "10.5,20.0,30.5");
      expect(field.evaluate(condition.operator, condition.value), isTrue);

      field.value = Decimal.parse("15.0");
      expect(field.evaluate(condition.operator, condition.value), isFalse);
    });
  });

  group("condition evaluation in form context", () {
    Form buildCategoryForm(String operator, String listValue) {
      return Form.withSection(
        "form1",
        [
          Section.withQuestions(
            "section1",
            [
              Question.withFields(
                "question1",
                [
                  SingleChoicesField(
                    "category",
                    "category",
                    [
                      ChoiceOption(label: "Category A", value: "A"),
                      ChoiceOption(label: "Category B", value: "B"),
                      ChoiceOption(label: "Category C", value: "C"),
                      ChoiceOption(label: "Category D", value: "D"),
                    ],
                  ),
                ],
              ),
              Question.withFields(
                "question2",
                [
                  TextField(
                    "detail",
                    "detail",
                    label: "Detail",
                    condition: SimpleCondition.fromJson({
                      "name": "category",
                      "operator": operator,
                      "value": listValue,
                    }),
                  ),
                ],
              ),
            ],
          )
        ],
      );
    }

    test("form field display with 'in' operator condition", () {
      final form = buildCategoryForm("in", "A,B");
      final detailField =
          form.values.getDelegate("detail")!.getField() as TextField;
      final categoryField =
          form.values.getDelegate("category")!.getField() as SingleChoicesField;

      expect(detailField.display, isFalse);

      categoryField.value = "A";
      expect(detailField.display, isTrue);

      categoryField.value = "B";
      expect(detailField.display, isTrue);

      categoryField.value = "C";
      expect(detailField.display, isFalse);

      categoryField.value = "D";
      expect(detailField.display, isFalse);
    });

    test("form field display with 'not_in' operator condition", () {
      final form = buildCategoryForm("not_in", "A,B");
      final detailField =
          form.values.getDelegate("detail")!.getField() as TextField;
      final categoryField =
          form.values.getDelegate("category")!.getField() as SingleChoicesField;

      // Exclusion list is A,B: detail shows only when category is outside that set.
      categoryField.value = "A";
      expect(detailField.display, isFalse);

      categoryField.value = "B";
      expect(detailField.display, isFalse);

      categoryField.value = "C";
      expect(detailField.display, isTrue);

      categoryField.value = "D";
      expect(detailField.display, isTrue);
    });
  });
}
