part of 'widgets.dart';

class FormDecimalField extends StatefulWidget {
  final opsv.DecimalField field;

  const FormDecimalField(this.field, {Key? key}) : super(key: key);

  @override
  State<FormDecimalField> createState() => _FormDecimalFieldState();
}

class _FormDecimalFieldState extends State<FormDecimalField> {
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
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: false,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
          TextInputFormatter.withFunction((oldValue, newValue) {
            try {
              final text = newValue.text;
              if (text.isNotEmpty) double.parse(text);
              return newValue;
            } catch (e) {
              _logger.e(e);
            }
            return oldValue;
          }),
        ],
        decoration: ohtkInputDecoration(
          hintText: widget.field.label,
          suffixText: widget.field.suffixLabel,
          isInvalid: isInvalid,
        ),
        onChanged: (val) {
          try {
            widget.field.value = val.isEmpty ? null : Decimal.parse(val);
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
