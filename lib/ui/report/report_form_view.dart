import 'package:flutter/material.dart' hide Form;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:podd_app/components/confirm.dart';
import 'package:podd_app/components/form_chrome.dart';
import 'package:podd_app/components/form_confirm.dart';
import 'package:podd_app/components/form_input.dart';
import 'package:podd_app/l10n/app_localizations.dart';
import 'package:podd_app/models/report_submit_result.dart';
import 'package:podd_app/ui/home/incidents_theme.dart';
import 'package:podd_app/ui/report/form_base_view_model.dart';
import 'package:podd_app/ui/report/report_form_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class ReportFormView extends StatelessWidget {
  final String reportTypeId;
  final bool testFlag;

  const ReportFormView(this.testFlag, this.reportTypeId, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportFormViewModel>.reactive(
      viewModelBuilder: () => ReportFormViewModel(testFlag, reportTypeId),
      builder: (context, viewModel, child) {
        if (!viewModel.isReady) {
          return const Scaffold(
            backgroundColor: incidentsSand,
            body: Center(
              child: CircularProgressIndicator(color: incidentsTeal),
            ),
          );
        }
        final localize = AppLocalizations.of(context)!;
        final reportName = viewModel.reportType?.name ?? '';
        final title = reportName.isEmpty
            ? localize.reportTitle
            : '${localize.reportTitle} $reportName';
        return ConfirmPopScope(
          onWillPop: () => _onWillpPop(context, viewModel),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: incidentsSand,
              appBar: FormChromeAppBar(
                title: title,
                onBack: () async {
                  if (await _onWillpPop(context, viewModel) &&
                      context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              body: SafeArea(
                top: false,
                child: Column(
                  children: [
                    FormChromeTestBanner(testFlag: testFlag),
                    if (viewModel.state == ReportFormState.formInput)
                      FormChromeProgressStrip(form: viewModel.formStore),
                    if (viewModel.state == ReportFormState.confirmation)
                      Expanded(
                        flex: 1,
                        child: FormConfirmSubmit(
                          busy: viewModel.isBusy,
                          showDataSummary: true,
                          dataSummary: viewModel.dataSummary,
                          authority: const _AuthorityRadios(),
                          onSubmit: () async {
                            final result = await viewModel.submit();
                            if (result is ReportSubmitSuccess ||
                                result is ReportSubmitPending) {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          onBack: () {
                            viewModel.back();
                          },
                        ),
                      ),
                    if (viewModel.state == ReportFormState.formInput)
                      Expanded(
                        flex: 1,
                        child: FormInput(
                          viewModel: viewModel,
                          onLastSectionValid: () {
                            viewModel.getReportDataSummary();
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onWillpPop(
      BuildContext context, ReportFormViewModel viewModel) async {
    if (viewModel.state == ReportFormState.confirmation) {
      viewModel.back();
      return false;
    }
    final discard = await showExitConfirmDialog(context);
    if (discard) {
      await viewModel.clearPendingFilesAndImages();
    }
    return discard;
  }

}

class _AuthorityRadios extends StackedHookView<ReportFormViewModel> {
  const _AuthorityRadios();

  @override
  Widget builder(BuildContext context, ReportFormViewModel viewModel) {
    return Observer(builder: (_) {
      final localize = AppLocalizations.of(context)!;
      final selected = viewModel.incidentInAuthority;
      return Column(
        children: [
          _AuthorityRadioRow(
            label: localize.yesAsAccept,
            selected: selected == true,
            onTap: () => viewModel.incidentInAuthority = true,
          ),
          const SizedBox(height: 4),
          _AuthorityRadioRow(
            label: localize.noAsReject,
            selected: selected == false,
            onTap: () => viewModel.incidentInAuthority = false,
          ),
        ],
      );
    });
  }
}

class _AuthorityRadioRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AuthorityRadioRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _RadioRing(selected: selected),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: incidentsFontFamily,
                  fontFamilyFallback: incidentsFontFamilyFallback,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: incidentsInk,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioRing extends StatelessWidget {
  final bool selected;
  const _RadioRing({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? incidentsTeal : incidentsHair,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: incidentsTeal,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
