part of 'widgets.dart';

class FormDateField extends StatefulWidget {
  final opsv.DateField field;

  const FormDateField(this.field, {Key? key}) : super(key: key);

  @override
  State<FormDateField> createState() => _FormDateFieldState();
}

class _FormDateFieldState extends State<FormDateField> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        if (!widget.field.display) return const SizedBox.shrink();
        return widget.field.separatedFields
            ? _DateTimeDropdown(widget.field)
            : _DateTimePicker(widget.field);
      },
    );
  }
}

class _DateTimeDropdown extends StatelessWidget {
  final opsv.DateField field;
  final currentYear = DateTime.now().year;

  _DateTimeDropdown(this.field, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (BuildContext context) {
      if (!field.display) return const SizedBox.shrink();
      return Row(
        children: [
          Expanded(flex: 1, child: _dayDropdown(field)),
          const SizedBox(width: 6),
          Expanded(flex: 2, child: _monthDropdown(field, context)),
          const SizedBox(width: 6),
          Expanded(flex: 1, child: _yearDropdown(field)),
          if (field.withTime) ...[
            const SizedBox(width: 6),
            Expanded(child: _hourDropdown(field)),
            const Text(
              ":",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: incidentsMuted,
              ),
            ),
            Expanded(child: _minuteDropdown(field)),
          ],
        ],
      );
    });
  }

  bool _isLeapYear(int? year) {
    return year != null &&
        ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0);
  }

  TextStyle _optionStyle(bool enabled) => TextStyle(
        fontFamily: incidentsFontFamily,
        fontFamilyFallback: incidentsFontFamilyFallback,
        color: enabled ? incidentsInk : incidentsHair,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );

  InputDecoration _dropdownDecoration({String? hint}) {
    final isInvalid = !field.isValid;
    return ohtkInputDecoration(hintText: hint, isInvalid: isInvalid);
  }

  Widget _dayDropdown(opsv.DateField field) {
    final items = List<int>.generate(31, (int index) => index).map((e) {
      final day = e + 1;
      bool enabled = true;
      if (field.month != null) {
        if (day == 29 && field.month == 2 && !_isLeapYear(field.year)) {
          enabled = false;
        }
        if (day == 30 && field.month == 2) enabled = false;
        if (day == 31 && [2, 4, 6, 9, 11].contains(field.month)) {
          enabled = false;
        }
      }
      return DropdownMenuItem(
        value: day,
        enabled: enabled,
        child: Text(day.toString(), style: _optionStyle(enabled)),
      );
    }).toList();

    return DropdownButtonFormField<int>(
      decoration: _dropdownDecoration(hint: "D"),
      initialValue: field.day,
      onChanged: (int? value) {
        field.day = value;
        if (!field.isValid) field.clearError();
      },
      items: items,
    );
  }

  Widget _monthDropdown(opsv.DateField field, BuildContext context) {
    final locale = Localizations.localeOf(context);
    final formatter = DateFormat.MMMM(locale.toString());
    final items = List<int>.generate(12, (int index) => index).map((e) {
      final month = e + 1;
      bool enabled = true;
      if (field.day != null) {
        if (field.day == 29 && month == 2 && !_isLeapYear(field.year)) {
          enabled = false;
        }
        if (field.day == 30 && month == 2) enabled = false;
        if (field.day == 31 && [2, 4, 6, 9, 11].contains(month)) {
          enabled = false;
        }
      }
      final monthStr = formatter.format(DateTime(2000, month, 1));
      return DropdownMenuItem(
        value: month,
        enabled: enabled,
        child: Text(monthStr, style: _optionStyle(enabled)),
      );
    }).toList();

    return DropdownButtonFormField<int>(
      decoration: _dropdownDecoration(hint: "M"),
      initialValue: field.month,
      onChanged: (int? value) {
        field.month = value;
        if (!field.isValid) field.clearError();
      },
      items: items,
    );
  }

  Widget _yearDropdown(opsv.DateField field) {
    final items = List<int>.generate(20, (int index) => index).map((e) {
      final year = e + currentYear - 9;
      bool enabled = true;
      if (field.day != null && field.month != null) {
        if (field.day == 29 && field.month == 2 && !_isLeapYear(year)) {
          enabled = false;
        }
      }
      return DropdownMenuItem(
        value: year,
        enabled: enabled,
        child: Text(year.toString(), style: _optionStyle(enabled)),
      );
    }).toList();

    return DropdownButtonFormField<int>(
      decoration: _dropdownDecoration(hint: "Y"),
      initialValue: field.year,
      onChanged: (int? value) {
        field.year = value;
        if (!field.isValid) field.clearError();
      },
      items: items,
    );
  }

  Widget _hourDropdown(opsv.DateField field) {
    final items = List<int>.generate(24, (int index) => index).map((e) {
      return DropdownMenuItem(
        value: e,
        child: Text(
          (e / 10 >= 1 ? "" : "0") + e.toString(),
          style: _optionStyle(true),
        ),
      );
    }).toList();

    return DropdownButtonFormField<int>(
      decoration: _dropdownDecoration(hint: "hh"),
      initialValue: field.hour,
      onChanged: (int? value) {
        field.hour = value;
        if (!field.isValid) field.clearError();
      },
      items: items,
    );
  }

  Widget _minuteDropdown(opsv.DateField field) {
    final items = List<int>.generate(60, (int index) => index).map((e) {
      return DropdownMenuItem(
        value: e,
        child: Text(
          (e / 10 >= 1 ? "" : "0") + e.toString(),
          style: _optionStyle(true),
        ),
      );
    }).toList();

    return DropdownButtonFormField<int>(
      decoration: _dropdownDecoration(hint: "mm"),
      initialValue: field.minute,
      onChanged: (int? value) {
        field.minute = value;
        if (!field.isValid) field.clearError();
      },
      items: items,
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  final opsv.DateField field;
  const _DateTimePicker(this.field, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (BuildContext context) {
      final datetime = field.value;
      if (!field.display) return const SizedBox.shrink();
      final isInvalid = !field.isValid;
      final borderColor = isInvalid ? incidentsErrorRed : incidentsHair;
      return Row(
        children: [
          Expanded(
            child: _DateTimePillButton(
              icon: Icons.calendar_today_outlined,
              value: datetime != null
                  ? '${datetime.day.toString().padLeft(2, '0')}/${datetime.month.toString().padLeft(2, '0')}/${datetime.year}'
                  : null,
              placeholder: 'DD/MM/YYYY',
              borderColor: borderColor,
              onTap: () =>
                  _showDialog(context, datetime, CupertinoDatePickerMode.date),
            ),
          ),
          if (field.withTime) ...[
            const SizedBox(width: 8),
            Expanded(
              child: _DateTimePillButton(
                icon: Icons.access_time,
                value: datetime != null
                    ? '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}'
                    : null,
                placeholder: 'HH:MM',
                borderColor: borderColor,
                onTap: () => _showDialog(
                  context,
                  datetime,
                  CupertinoDatePickerMode.time,
                ),
              ),
            ),
          ],
        ],
      );
    });
  }

  Future<void> _showDialog(
    BuildContext context,
    DateTime? datetime,
    CupertinoDatePickerMode mode,
  ) async {
    if (Platform.isIOS) {
      final child = CupertinoDatePicker(
        initialDateTime: datetime,
        mode: mode,
        use24hFormat: true,
        onDateTimeChanged: (DateTime newTime) {
          field.value = newTime;
          if (!field.isValid) field.clearError();
        },
      );
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(top: false, child: child),
        ),
      );
    } else {
      final DateTime now = DateTime.now();
      if (mode == CupertinoDatePickerMode.date) {
        final DateTime? picked = await showDatePicker(
          context: context,
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 50),
          initialDate: datetime ?? now,
        );
        if (picked != null) {
          field.value = picked;
          if (!field.isValid) field.clearError();
        }
      } else {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: datetime != null
              ? TimeOfDay(hour: datetime.hour, minute: datetime.minute)
              : TimeOfDay.now(),
        );
        if (picked != null) {
          if (datetime != null) {
            field.value = DateTime(
              datetime.year,
              datetime.month,
              datetime.day,
              picked.hour,
              picked.minute,
            );
          } else {
            field.value = DateTime(
              now.year,
              now.month,
              now.day,
              picked.hour,
              picked.minute,
            );
          }
          if (!field.isValid) field.clearError();
        }
      }
    }
  }
}

class _DateTimePillButton extends StatelessWidget {
  final IconData icon;
  final String? value;
  final String placeholder;
  final Color borderColor;
  final VoidCallback onTap;

  const _DateTimePillButton({
    required this.icon,
    required this.value,
    required this.placeholder,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          child: Row(
            children: [
              Icon(icon, size: 16, color: incidentsMuted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasValue ? value! : placeholder,
                  style: hasValue ? ohtkInputTextStyle : _ohtkInputHintStyle,
                ),
              ),
              const Icon(Icons.expand_more, size: 18, color: incidentsMuted),
            ],
          ),
        ),
      ),
    );
  }
}
