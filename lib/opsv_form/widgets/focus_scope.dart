part of 'widgets.dart';

class FormTextInputFocusController {
  final Map<opsv.Field, FocusNode> _nodes = {};
  List<opsv.Field> _visibleTextFields = const [];

  void sync(List<opsv.Question> questions) {
    final visibleTextFields = <opsv.Field>[];

    for (final question in questions) {
      if (!question.display) continue;

      for (final field in question.fields) {
        if (field.display && _isTextInput(field)) {
          visibleTextFields.add(field);
        }
      }
    }

    final nextFields = visibleTextFields.toSet();
    final removedFields =
        _nodes.keys.where((field) => !nextFields.contains(field)).toList();
    for (final field in removedFields) {
      final node = _nodes.remove(field);
      if (node == null) continue;
      if (node.hasFocus) node.unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        node.dispose();
      });
    }

    _visibleTextFields = visibleTextFields;
  }

  FocusNode nodeFor(opsv.Field field) {
    return _nodes.putIfAbsent(field, () {
      final node = FocusNode(debugLabel: 'opsv_form_${field.name}');
      node.addListener(() {
        if (node.hasFocus) _ensureFocusedInputVisible(node);
      });
      return node;
    });
  }

  TextInputAction textInputActionFor(opsv.Field field) {
    if (field is opsv.TextareaField) return TextInputAction.newline;
    return _nextFieldAfter(field) == null
        ? TextInputAction.done
        : TextInputAction.next;
  }

  void completeEditing(BuildContext context, opsv.Field field) {
    final nextField = _nextFieldAfter(field);
    if (nextField == null) {
      nodeFor(field).unfocus();
      return;
    }

    final nextNode = nodeFor(nextField);
    FocusScope.of(context).requestFocus(nextNode);
    _ensureFocusedInputVisible(nextNode);
  }

  void dispose() {
    for (final node in _nodes.values) {
      node.dispose();
    }
    _nodes.clear();
  }

  static bool _isTextInput(opsv.Field field) {
    return field is opsv.TextField ||
        field is opsv.IntegerField ||
        field is opsv.DecimalField ||
        field is opsv.TextareaField;
  }

  opsv.Field? _nextFieldAfter(opsv.Field field) {
    final index = _visibleTextFields.indexOf(field);
    if (index == -1 || index + 1 >= _visibleTextFields.length) {
      return null;
    }
    return _visibleTextFields[index + 1];
  }

  void _ensureFocusedInputVisible(FocusNode node) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = node.context;
      if (context == null || !node.hasFocus) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 180),
        alignment: 0.12,
        curve: Curves.easeOut,
      );
    });
  }
}

class FormTextInputFocusScope extends InheritedWidget {
  final FormTextInputFocusController controller;

  const FormTextInputFocusScope({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  static FormTextInputFocusController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FormTextInputFocusScope>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(FormTextInputFocusScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
