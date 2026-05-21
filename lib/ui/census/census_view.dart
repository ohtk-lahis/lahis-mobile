import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:podd_app/models/census_definition.dart';
import 'package:podd_app/theme/ohtk_style_system.dart';
import 'package:podd_app/ui/census/census_view_model.dart';
import 'package:podd_app/ui/home/incidents_theme.dart';
import 'package:stacked/stacked.dart';

class CensusView extends StatelessWidget {
  final String? kind;

  const CensusView({Key? key, this.kind}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CensusViewModel>.reactive(
      viewModelBuilder: () => CensusViewModel(kind: kind),
      builder: (context, viewModel, _) {
        if (viewModel.isBusy) {
          if (kind != null) {
            return _CensusFormScaffold(
              title: _kindTitle(kind),
              body: const _CensusLoading(),
            );
          }
          return const _CensusLoading();
        }

        if (!viewModel.hasCensusAccess) {
          const state = _FullState(
            icon: Icons.lock_outline,
            title: 'Census is not available',
            message: 'This account is not assigned to update a village census.',
          );
          if (kind != null) {
            return _CensusFormScaffold(
              title: _kindTitle(kind),
              body: state,
            );
          }
          return state;
        }

        if (viewModel.hasError && !viewModel.hasRows) {
          final state = _FullState(
            icon: Icons.cloud_off_outlined,
            title: "Couldn't load the census",
            message: viewModel.modelError.toString(),
            actionLabel: 'Try again',
            onAction: viewModel.init,
          );
          if (viewModel.isHubMode) {
            return state;
          }
          return _CensusFormScaffold(
            title: viewModel.activeKindName,
            body: state,
          );
        }

        if (viewModel.isHubMode) {
          return _CensusHub(viewModel: viewModel);
        }

        if (viewModel.unsupportedSchema) {
          return _CensusFormScaffold(
            title: viewModel.activeKindName,
            body: const _FullState(
              icon: Icons.warning_amber_rounded,
              iconColor: Color(0xFFA07015),
              iconBackground: Color(0x1AA07015),
              title: 'This census needs a newer app',
              message:
                  "The village census has been updated and isn't supported on this version of OHTK Mobile. Please update the app, then try again.",
            ),
          );
        }

        return _CensusFormScaffold(
          title: viewModel.activeKindName,
          footer: _StickyFooter(viewModel: viewModel),
          body: RefreshIndicator(
            color: incidentsTeal,
            onRefresh: viewModel.init,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _VillageHeader(viewModel: viewModel),
                if (viewModel.usingCachedDefinition)
                  const _NoticeBanner(
                    tone: _NoticeTone.warn,
                    icon: Icons.warning_amber_rounded,
                    text:
                        "Using a saved version of this form — couldn't refresh from server.",
                  ),
                if (viewModel.message != null)
                  _NoticeBanner(
                    tone: _NoticeTone.ok,
                    icon: Icons.check_circle_outline,
                    text: viewModel.message!,
                  ),
                if (viewModel.hasErrorForKey('submit'))
                  _NoticeBanner(
                    tone: _NoticeTone.error,
                    icon: Icons.error_outline,
                    text: viewModel.error('submit').toString(),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.latestCensus == null
                            ? 'No census has been submitted yet. Enter the current values for each row.'
                            : 'Update anything that has changed. Numbers from the last submission are pre-filled.',
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: incidentsBody,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!viewModel.hasRows)
                        const Text(
                          'No active census rows are configured.',
                          style: TextStyle(
                            color: incidentsBody,
                          ),
                        )
                      else
                        for (var i = 0; i < viewModel.rows.length; i++)
                          _CensusRowSection(
                            row: viewModel.rows[i],
                            viewModel: viewModel,
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _kindTitle(String? kind) {
  final normalized = kind?.trim().toUpperCase();
  if (normalized == 'ANIMAL') {
    return 'Animal census';
  }
  if (normalized == 'HUMAN') {
    return 'Human census';
  }
  return 'Census';
}

class _CensusFormScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? footer;

  const _CensusFormScaffold({
    required this.title,
    required this.body,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: incidentsSand,
      appBar: AppBar(
        backgroundColor: incidentsTealDeep,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/census');
            }
          },
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: body),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

class _CensusHub extends StatelessWidget {
  final CensusViewModel viewModel;

  const _CensusHub({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.censusKinds.isEmpty) {
      return Column(
        children: [
          _VillageHeader(viewModel: viewModel, showFreshness: false),
          const Expanded(
            child: _FullState(
              icon: Icons.info_outline,
              iconColor: incidentsTeal,
              iconBackground: Color(0x1A0F8A82),
              title: 'No census set up',
              message:
                  'This village does not have an active census form configured.',
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      color: incidentsTeal,
      onRefresh: viewModel.init,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _VillageHeader(viewModel: viewModel, showFreshness: false),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.censusKinds.length == 1
                      ? 'Choose to keep this census up to date.'
                      : 'Choose a census to update. Each one is saved separately.',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: incidentsBody,
                  ),
                ),
                const SizedBox(height: 14),
                for (final summary in viewModel.censusKinds)
                  _CensusKindCard(
                    summary: summary,
                    onTap: () async {
                      await context
                          .push('/census/${summary.kind.toLowerCase()}');
                      if (context.mounted) {
                        await viewModel.init();
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CensusKindCard extends StatelessWidget {
  final CensusKindSummary summary;
  final VoidCallback onTap;

  const _CensusKindCard({
    required this.summary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OhtkCard(
        onTap: onTap,
        child: Row(
          children: [
            OhtkIconTile(
              size: 44,
              icon: summary.kind == 'HUMAN'
                  ? Icons.groups_outlined
                  : Icons.pets_outlined,
            ),
            const SizedBox(width: OhtkSpace.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summary.displayName,
                    style: OhtkType.h3.copyWith(
                    ),
                  ),
                  const SizedBox(height: 7),
                  OhtkChip(
                    icon: summary.latestSnapshot != null
                        ? Icons.access_time_rounded
                        : Icons.edit_outlined,
                    label: summary.latestSnapshot != null
                        ? 'Last updated ${_dateOnly(summary.latestSnapshot!.censusDate)}'
                        : 'Never submitted',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.chevron_right_rounded,
              color: incidentsTeal,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  static String _dateOnly(DateTime? date) {
    if (date == null) {
      return '';
    }
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');
    return '$day/$month/$year';
  }
}

class _VillageHeader extends StatelessWidget {
  final CensusViewModel viewModel;
  final bool showFreshness;

  const _VillageHeader({
    required this.viewModel,
    this.showFreshness = true,
  });

  @override
  Widget build(BuildContext context) {
    final village = viewModel.selectedVillage;
    final freshness = viewModel.freshnessLabel;
    return OhtkCard(
      margin: const EdgeInsets.fromLTRB(
        OhtkLayout.pagePad,
        OhtkSpace.md,
        OhtkLayout.pagePad,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const OhtkIconTile(
                size: 48,
                icon: Icons.holiday_village_outlined,
              ),
              const SizedBox(width: OhtkSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OhtkEyebrow(label: 'UPDATING VILLAGE'),
                    const SizedBox(height: 2),
                    Text(
                      village?.displayName ?? 'No village',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: OhtkType.h3.copyWith(
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showFreshness) ...[
            const SizedBox(height: 12),
            OhtkChip(
              icon: freshness == null
                  ? Icons.edit_outlined
                  : Icons.access_time_rounded,
              label: freshness == null
                  ? 'No census submitted yet'
                  : 'Last updated $freshness',
            ),
          ],
        ],
      ),
    );
  }
}

class _CensusRowSection extends StatelessWidget {
  final CensusSchemaRow row;
  final CensusViewModel viewModel;

  const _CensusRowSection({
    required this.row,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final dirty = viewModel.isRowDirty(row);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: incidentsInk,
                    ),
                  ),
                ),
                if (dirty)
                  const Text(
                    'EDITED',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: incidentsTeal,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          OhtkCard(
            padding: EdgeInsets.zero,
            borderColor: dirty ? incidentsTeal : incidentsHair,
            boxShadow: dirty
                ? [
                    BoxShadow(
                      color: incidentsTeal.withValues(alpha: 0.10),
                      spreadRadius: 3,
                      blurRadius: 0,
                    )
                  ]
                : null,
            child: Column(
              children: [
                for (var i = 0; i < viewModel.measures.length; i++)
                  _MeasureInputRow(
                    row: row,
                    measure: viewModel.measures[i],
                    viewModel: viewModel,
                    last: i == viewModel.measures.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasureInputRow extends StatelessWidget {
  final CensusSchemaRow row;
  final CensusSchemaMeasure measure;
  final CensusViewModel viewModel;
  final bool last;

  const _MeasureInputRow({
    required this.row,
    required this.measure,
    required this.viewModel,
    required this.last,
  });

  @override
  Widget build(BuildContext context) {
    final label = measure.label.isNotEmpty ? measure.label : measure.key;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: incidentsHair)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                height: 1.2,
                fontWeight: FontWeight.w500,
                color: incidentsBody,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: TextFormField(
              key: ValueKey('${row.rowKey}:${measure.key}'),
              initialValue: viewModel.measureValue(row.rowKey, measure.key),
              focusNode: viewModel.focusNodeFor(row, measure),
              enabled: !viewModel.busy('submit'),
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              textInputAction: viewModel.textInputActionFor(row, measure),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onEditingComplete: () =>
                  viewModel.completeEditing(context, row, measure),
              onChanged: (value) =>
                  viewModel.setMeasureValue(row.rowKey, measure.key, value),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: incidentsInk,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                filled: viewModel.busy('submit'),
                fillColor: incidentsSand,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: incidentsHair, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: incidentsHair, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: incidentsTeal, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyFooter extends StatelessWidget {
  final CensusViewModel viewModel;

  const _StickyFooter({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: OhtkColor.line)),
        boxShadow: OhtkShadow.sticky,
      ),
      padding: const EdgeInsets.fromLTRB(
        OhtkLayout.pagePad,
        OhtkSpace.sm,
        OhtkLayout.pagePad,
        18,
      ),
      child: OhtkPrimaryButton(
        label: 'Save current census',
        loading: viewModel.busy('submit'),
        onPressed: viewModel.canSubmit ? () => viewModel.submit() : null,
      ),
    );
  }
}

enum _NoticeTone { ok, warn, error }

class _NoticeBanner extends StatelessWidget {
  final _NoticeTone tone;
  final IconData icon;
  final String text;

  const _NoticeBanner({
    required this.tone,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      _NoticeTone.ok => incidentsTeal,
      _NoticeTone.warn => const Color(0xFFA07015),
      _NoticeTone.error => incidentsErrorRed,
    };
    final background = switch (tone) {
      _NoticeTone.ok => incidentsTeal.withValues(alpha: 0.10),
      _NoticeTone.warn => const Color(0x1AA07015),
      _NoticeTone.error => incidentsErrorTint,
    };
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullState extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _FullState({
    required this.icon,
    required this.title,
    required this.message,
    this.iconColor = incidentsErrorRed,
    this.iconBackground = incidentsErrorTint,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, color: iconColor, size: 38),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: incidentsInk,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.55,
                color: incidentsMuted,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh, size: 15),
                label: Text(actionLabel!.toUpperCase()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: incidentsTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CensusLoading extends StatelessWidget {
  const _CensusLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(14),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Skeleton(width: 120, height: 12),
              SizedBox(height: 8),
              _Skeleton(width: 240, height: 15),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: const [
              _SkeletonCard(),
              SizedBox(height: 12),
              _SkeletonCard(),
              SizedBox(height: 12),
              _SkeletonCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: incidentsHair),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Skeleton(width: 120, height: 14),
          SizedBox(height: 14),
          _Skeleton(width: double.infinity, height: 42),
          SizedBox(height: 8),
          _Skeleton(width: double.infinity, height: 42),
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  final double width;
  final double height;

  const _Skeleton({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: incidentsHair.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
