import 'package:flutter/material.dart';
import 'package:podd_app/components/back_appbar_action.dart';
import 'package:podd_app/components/progress_indicator.dart';
import 'package:podd_app/components/report_file_grid_view.dart';
import 'package:podd_app/components/report_image_carousel.dart';
import 'package:podd_app/l10n/app_localizations.dart';
import 'package:podd_app/models/entities/observation_subject_monitoring.dart';
import 'package:podd_app/theme/ohtk_style_system.dart';
import 'package:podd_app/ui/observation/monitoring/observation_monitoring_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class ObservationMonitoringRecordView extends StatelessWidget {
  final String monitoringRecordId;

  const ObservationMonitoringRecordView({
    Key? key,
    required this.monitoringRecordId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ObservationMonitoringRecordViewModel>.reactive(
      viewModelBuilder: () => ObservationMonitoringRecordViewModel(
        monitoringRecordId: monitoringRecordId,
      ),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: OhtkColor.cream,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.observationSubjectMonitoringViewTitle,
          ),
          leading: const BackAppBarAction(),
          automaticallyImplyLeading: false,
        ),
        body: viewModel.isBusy
            ? const Center(child: OhtkProgressIndicator(size: 100))
            : viewModel.hasError
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Monitoring record not found',
                        style: TextStyle(color: OhtkColor.ink500),
                      ),
                    ),
                  )
                : _bodyView(context, viewModel),
      ),
    );
  }

  Widget _bodyView(
      BuildContext context, ObservationMonitoringRecordViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        OhtkLayout.pagePad,
        OhtkSpace.lg,
        OhtkLayout.pagePad,
        OhtkSpace.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MonitoringRecordDetail(),
          if (viewModel.data!.images?.isNotEmpty ?? false) ...[
            const SizedBox(height: OhtkLayout.sectionGap),
            const _SectionLabel(label: 'Images'),
            const SizedBox(height: OhtkSpace.xs),
            ReportImagesCarousel(viewModel.data!.images),
          ],
          if (viewModel.data!.files?.isNotEmpty ?? false) ...[
            const SizedBox(height: OhtkLayout.sectionGap),
            const _SectionLabel(label: 'Files'),
            const SizedBox(height: OhtkSpace.xs),
            ReportFileGridView(viewModel.data!.files),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: OhtkEyebrow(label: label),
    );
  }
}

class _MonitoringRecordDetail
    extends StackedHookView<ObservationMonitoringRecordViewModel> {
  @override
  Widget builder(
      BuildContext context, ObservationMonitoringRecordViewModel viewModel) {
    final record = viewModel.data!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderCard(record: record),
        if (record.formData != null && record.formData!.isNotEmpty) ...[
          const SizedBox(height: OhtkLayout.rowGap),
          _DataCard(formData: record.formData!),
        ],
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final ObservationMonitoringRecord record;

  const _HeaderCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final title = record.title.isNotEmpty ? record.title : 'No title';
    final description = record.description;

    return OhtkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: OhtkColor.ink900,
              height: 1.3,
            ),
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: OhtkSpace.sm),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: OhtkColor.ink700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final Map<String, dynamic> formData;

  const _DataCard({required this.formData});

  @override
  Widget build(BuildContext context) {
    final rows = formData.entries
        .where((e) => !e.key.contains('__value') && e.value != null)
        .toList();

    if (rows.isEmpty) return const SizedBox.shrink();

    return OhtkCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < rows.length; i++)
            Container(
              decoration: BoxDecoration(
                border: i == rows.length - 1
                    ? null
                    : const Border(
                        bottom: BorderSide(color: OhtkColor.lineSoft),
                      ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: OhtkLayout.cardPad,
                vertical: OhtkSpace.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      rows[i].key,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: OhtkColor.ink500,
                      ),
                    ),
                  ),
                  const SizedBox(width: OhtkSpace.md),
                  Expanded(
                    flex: 2,
                    child: Text(
                      rows[i].value.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: OhtkColor.ink900,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
