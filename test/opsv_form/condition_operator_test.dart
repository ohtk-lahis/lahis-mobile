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

  group("condition operator 'in' (alias for isOneOf)", () {
    test("parse 'in' operator from json", () {
      var condition = SimpleCondition.fromJson({
        "name": "category",
        "operator": "in",
        "value": "A,B,C",
      });
      expect(condition.operator, ConditionOperator.isOneOf);
    });

    test("TextField with 'in' operator - value in list", () {
      var textField = TextField("id1", "category");
      textField.value = "Bz";
      
      var result = textField.evaluate(ConditionOperator.isOneOf, "A,B,C");
      expect(result, isTrue);
    });

    test("TextField with 'in' operator - value not in list", () {
      var textField = TextField("id1", "category");
      textField.value = "D";
      
      var result = textField.evaluate(ConditionOperator.isOneOf, "A,B,C");
      expect(result, isFalse);
    });

    test("TextField with 'in' operator - with spaces in list", () {
      var textField = TextField("id1", "category");
      textField.value = "B";
      
      var result = textField.evaluate(ConditionOperator.isOneOf, "A, B, C");
      expect(result, isTrue);
    });

    test("IntegerField with 'in' operator - value in list", () {
      var intField = IntegerField("id1", "age");
      intField.value = 25;
      
      var result = intField.evaluate(ConditionOperator.isOneOf, "18,25,30");
      expect(result, isTrue);
    });

    test("IntegerField with 'in' operator - value not in list", () {
      var intField = IntegerField("id1", "age");
      intField.value = 26;
      
      var result = intField.evaluate(ConditionOperator.isOneOf, "18,25,30");
      expect(result, isFalse);
    });

    test("SingleChoicesField with 'in' operator - value in list", () {
      var singleChoiceField = SingleChoicesField(
        "id1",
        "color",
        [
          ChoiceOption(label: "Red", value: "red"),
          ChoiceOption(label: "Blue", value: "blue"),
          ChoiceOption(label: "Green", value: "green"),
        ],
      );
      singleChoiceField.value = "blue";
      
      var result = singleChoiceField.evaluate(ConditionOperator.isOneOf, "red,blue");
      expect(result, isTrue);
    });

    test("SingleChoicesField with 'in' operator - value not in list", () {
      var singleChoiceField = SingleChoicesField(
        "id1",
        "color",
        [
          ChoiceOption(label: "Red", value: "red"),
          ChoiceOption(label: "Blue", value: "blue"),
          ChoiceOption(label: "Green", value: "green"),
        ],
      );
      singleChoiceField.value = "green";
      
      var result = singleChoiceField.evaluate(ConditionOperator.isOneOf, "red,blue");
      expect(result, isFalse);
    });

    test("DecimalField with 'in' operator - value in list", () {
      var decimalField = DecimalField("id1", "price");
      decimalField.value = Decimal.parse("10.5");
      
      var result = decimalField.evaluate(ConditionOperator.isOneOf, "10.5,20.0,30.5");
      expect(result, isTrue);
    });

    test("DecimalField with 'in' operator - value not in list", () {
      var decimalField = DecimalField("id1", "price");
      decimalField.value = Decimal.parse("15.0");
      
      var result = decimalField.evaluate(ConditionOperator.isOneOf, "10.5,20.0,30.5");
      expect(result, isFalse);
    });

    test("LocationField with 'in' operator - value in list (simple IDs)", () {
      // Note: LocationField stores "lng,lat" which makes isOneOf impractical with comma-separated values
      // This test demonstrates the behavior with simple string IDs instead
      var locationField = LocationField("id1", "location");
      locationField.value = "loc1";
      
      var result = locationField.evaluate(ConditionOperator.isOneOf, "loc1,loc2,loc3");
      expect(result, isTrue);
      
      locationField.value = "loc4";
      result = locationField.evaluate(ConditionOperator.isOneOf, "loc1,loc2,loc3");
      expect(result, isFalse);
    });

    test("DateField with 'in' operator - value in list", () {
      var dateField = DateField("id1", "date");
      var date1 = DateTime(2023, 1, 1);
      dateField.value = date1;
      
      var isoString = date1.toIso8601String();
      var result = dateField.evaluate(ConditionOperator.isOneOf, "$isoString,2023-02-01T00:00:00.000");
      expect(result, isTrue);
    });
  });

  group("backward compatibility - hasOneOf and isOneOf", () {
    test("parse 'hasOneOf' operator from json", () {
      var condition = SimpleCondition.fromJson({
        "name": "category",
        "operator": "hasOneOf",
        "value": "A,B,C",
      });
      expect(condition.operator, ConditionOperator.isOneOf);
    });

    test("parse 'has_one_of' operator from json", () {
      var condition = SimpleCondition.fromJson({
        "name": "category",
        "operator": "has_one_of",
        "value": "A,B,C",
      });
      expect(condition.operator, ConditionOperator.isOneOf);
    });

    test("parse 'isOneOf' operator from json", () {
      var condition = SimpleCondition.fromJson({
        "name": "category",
        "operator": "isOneOf",
        "value": "A,B,C",
      });
      expect(condition.operator, ConditionOperator.isOneOf);
    });
  });

  group("condition evaluation in form context", () {
    test("form field display with 'in' operator condition", () {
      var form = Form.withSection(
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
                      "operator": "in",
                      "value": "A,B",
                    }),
                  ),
                ],
              ),
            ],
          )
        ],
      );

      TextField detailField =
          form.values.getDelegate("detail")!.getField() as TextField;
      SingleChoicesField categoryField =
          form.values.getDelegate("category")!.getField() as SingleChoicesField;

      // Initially detail field should not display
      expect(detailField.display, isFalse);

      // Set category to A (in the list)
      categoryField.value = "A";
      expect(detailField.display, isTrue);

      // Set category to B (in the list)
      categoryField.value = "B";
      expect(detailField.display, isTrue);

      // Set category to C (not in the list)
      categoryField.value = "C";
      expect(detailField.display, isFalse);

      // Set category to D (not in the list)
      categoryField.value = "D";
      expect(detailField.display, isFalse);
    });
  });
}
