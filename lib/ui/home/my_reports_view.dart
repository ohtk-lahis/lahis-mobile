import 'package:flutter/material.dart';
import 'package:podd_app/components/progress_indicator.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/ui/home/my_reports_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'report_list_view.dart';

class MyReportsView extends StatefulWidget {
  const MyReportsView({Key? key}) : super(key: key);

  @override
  State<MyReportsView> createState() => _MyReportsViewState();
}

class _MyReportsViewState extends State<MyReportsView>
    with AutomaticKeepAliveClientMixin {
  final viewModel = locator<MyReportsViewModel>();

  @override
  bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<MyReportsViewModel>.nonReactive(
        viewModelBuilder: () => viewModel,
        disposeViewModel: false,
        initialiseSpecialViewModelsOnce: true,
        builder: (context, viewModel, child) => _ReportList());
  }
}

class _ReportList extends StackedHookView<MyReportsViewModel> {
  @override
  Widget builder(BuildContext context, MyReportsViewModel viewModel) {
    return RefreshIndicator(
      onRefresh: () async {
        await viewModel.refetchIncidentReports();
      },
      child: !viewModel.isBusy
          ? ReportListView(
              viewModel: viewModel,
              key: const PageStorageKey('my-reports-storage-key'),
            )
          : const Center(
              child: OhtkProgressIndicator(
              size: 100,
            )),
    );
  }
}
