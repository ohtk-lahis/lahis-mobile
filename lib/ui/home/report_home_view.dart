import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:podd_app/l10n/app_localizations.dart';
import 'package:podd_app/router.dart';
import 'package:podd_app/ui/home/all_reports_view.dart';
import 'package:podd_app/ui/home/incidents_theme.dart';
import 'package:podd_app/ui/home/my_reports_view.dart';
import 'package:podd_app/ui/home/report_home_view_model.dart';
import 'package:stacked/stacked.dart';

class ReportHomeView extends HookWidget {
  const ReportHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    final selectedIndex = useState(0);

    useEffect(() {
      void listener() {
        if (!tabController.indexIsChanging) {
          selectedIndex.value = tabController.index;
        } else {
          selectedIndex.value = tabController.index;
        }
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    return ViewModelBuilder<ReportHomeViewModel>.nonReactive(
      viewModelBuilder: () => ReportHomeViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: incidentsSand,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: _TabsStrip(
            controller: tabController,
            activeIndex: selectedIndex.value,
            labels: [
              AppLocalizations.of(context)!.allReportTabLabel,
              AppLocalizations.of(context)!.myReportTabLabel,
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 2, bottom: 16),
          child: SizedBox(
            width: 56,
            height: 56,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x38000000),
                    offset: Offset(0, 6),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: FloatingActionButton(
                backgroundColor: incidentsFabGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                highlightElevation: 0,
                shape: const CircleBorder(),
                onPressed: () {
                  GoRouter.of(context).goNamed(OhtkRouter.reportTypes);
                },
                child: const Icon(Icons.add, size: 24),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            AllReportsView(),
            MyReportsView(),
          ],
        ),
      ),
    );
  }
}

class _TabsStrip extends StatelessWidget {
  final TabController controller;
  final int activeIndex;
  final List<String> labels;

  const _TabsStrip({
    required this.controller,
    required this.activeIndex,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: incidentsHair)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++)
            Expanded(
              child: _TabButton(
                label: labels[i],
                selected: activeIndex == i,
                onTap: () => controller.animateTo(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? incidentsTeal : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: incidentsFontFamily,
            fontFamilyFallback: incidentsFontFamilyFallback,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: selected ? incidentsTeal : incidentsMuted,
          ),
        ),
      ),
    );
  }
}
