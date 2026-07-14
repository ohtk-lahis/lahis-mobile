part of 'widgets.dart';

const _questionInvalidBorder = Color(0xFFE8B6AB);
const _questionErrorPillBg = Color(0xFFFBEAE5);

class FormQuestion extends StatelessWidget {
  final opsv.Question question;

  const FormQuestion({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        if (!question.display) {
          return const SizedBox.shrink();
        }
        final visibleFields =
            question.fields.where((f) => f.display).toList(growable: false);
        final firstInvalid = visibleFields
            .cast<opsv.Field?>()
            .firstWhere((f) => f?.isValid == false, orElse: () => null);
        final hasError = firstInvalid != null;
        final isRequired = question.fields.any((f) => f.required == true);

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? _questionInvalidBorder : incidentsHair,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QuestionLabel(label: question.label, required: isRequired),
              if (question.description != null &&
                  question.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  question.description!,
                  style: const TextStyle(
                    fontFamily: incidentsFontFamily,
                    fontFamilyFallback: incidentsFontFamilyFallback,
                    fontSize: 12,
                    color: incidentsMuted,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              ...visibleFields.expand((f) sync* {
                final showSubLabel = visibleFields.length > 1 &&
                    (f.label ?? '').isNotEmpty &&
                    f.label != question.label;
                if (showSubLabel) {
                  yield _FieldSubLabel(
                    label: f.label!,
                    required: f.required == true,
                  );
                  yield const SizedBox(height: 6);
                }
                yield FormField(field: f);
                if (f != visibleFields.last) yield const SizedBox(height: 14);
              }),
              if (hasError) ...[
                const SizedBox(height: 10),
                _ErrorPill(
                  message: firstInvalid.invalidMessage ?? '',
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _QuestionLabel extends StatelessWidget {
  final String label;
  final bool required;

  const _QuestionLabel({required this.label, required this.required});

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: incidentsFontFamily,
          fontFamilyFallback: incidentsFontFamilyFallback,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: incidentsInk,
          height: 1.35,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: incidentsErrorRed),
            ),
        ],
      ),
    );
  }
}

class _FieldSubLabel extends StatelessWidget {
  final String label;
  final bool required;

  const _FieldSubLabel({required this.label, required this.required});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: incidentsFontFamily,
          fontFamilyFallback: incidentsFontFamilyFallback,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: incidentsBody,
          height: 1.35,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: incidentsErrorRed),
            ),
        ],
      ),
    );
  }
}

class _ErrorPill extends StatelessWidget {
  final String message;

  const _ErrorPill({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _questionErrorPillBg,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.error_outline,
              size: 14,
              color: incidentsErrorRed,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: incidentsFontFamily,
                fontFamilyFallback: incidentsFontFamilyFallback,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: incidentsErrorRed,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
