import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:podd_app/components/form_footer.dart';
import 'package:podd_app/opsv_form/opsv_form.dart' as opsv;
import 'package:podd_app/opsv_form/widgets/widgets.dart';
import 'package:podd_app/ui/report/form_base_view_model.dart';

class FormInput extends StatefulWidget {
  final FormBaseViewModel viewModel;
  final OnLastSectionValid? onLastSectionValid;

  const FormInput({
    required this.viewModel,
    this.onLastSectionValid,
    Key? key,
  }) : super(key: key);

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  final ScrollController _scrollController = ScrollController();
  final FormTextInputFocusController _textInputFocusController =
      FormTextInputFocusController();
  final Map<opsv.Question, GlobalKey> _questionKeys = {};

  GlobalKey _keyFor(opsv.Question q) =>
      _questionKeys.putIfAbsent(q, () => GlobalKey());

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }

  void _scrollToInvalid(int index) {
    final questions = widget.viewModel.formStore.currentSection.questions;
    if (index < 0 || index >= questions.length) return;
    final ctx = _questionKeys[questions[index]]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 200),
      alignment: 0.1,
    );
  }

  @override
  void dispose() {
    _textInputFocusController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final questions = widget.viewModel.formStore.currentSection.questions;
        _textInputFocusController.sync(questions);
        return FormTextInputFocusScope(
          controller: _textInputFocusController,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    children: [
                      for (final q in questions)
                        FormQuestion(key: _keyFor(q), question: q),
                    ],
                  ),
                ),
              ),
              FormFooter(
                viewModel: widget.viewModel,
                onScrollToTop: _scrollToTop,
                onScrollToInvalid: _scrollToInvalid,
                onLastSectionValid: widget.onLastSectionValid,
              ),
            ],
          ),
        );
      },
    );
  }
}
