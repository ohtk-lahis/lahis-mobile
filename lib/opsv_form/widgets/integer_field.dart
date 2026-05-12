part of 'widgets.dart';

class FormIntegerField extends StatefulWidget {
  final opsv.IntegerField field;

  const FormIntegerField(this.field, {Key? key}) : super(key: key);

  @override
  State<FormIntegerField> createState() => _FormIntegerFieldState();
}

class _FormIntegerFieldState extends State<FormIntegerField> {
  final TextEditingController _controller = TextEditingController();
  final _logger = locator<Logger>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (BuildContext context) {
      if (!widget.field.display) return const SizedBox.shrink();
      final value = widget.field.value?.toString() ?? '';
      if (value != _controller.text) {
        _controller.value = TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
      }
      final isInvalid = !widget.field.isValid;
      final focusController = FormTextInputFocusScope.maybeOf(context);
      return TextField(
        controller: _controller,
        focusNode: focusController?.nodeFor(widget.field),
        style: ohtkInputTextStyle,
        textInputAction: focusController?.textInputActionFor(widget.field) ??
            TextInputAction.next,
        onEditingComplete: focusController == null
            ? null
            : () => focusController.completeEditing(context, widget.field),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: ohtkInputDecoration(
          hintText: widget.field.label,
          suffixText: widget.field.suffixLabel,
          isInvalid: isInvalid,
        ),
        onChanged: (val) {
          try {
            widget.field.value = val.isEmpty ? null : int.parse(val);
          } on FormatException catch (_) {
            _logger.e("parsing error ${val.toString()}");
            widget.field.value = null;
          }
          if (isInvalid) widget.field.clearError();
        },
      );
    });
  }
}
