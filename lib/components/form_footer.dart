import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:logger/logger.dart';
import 'package:podd_app/components/form_chrome.dart';
import 'package:podd_app/l10n/app_localizations.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/ui/home/incidents_theme.dart';
import 'package:podd_app/ui/report/form_base_view_model.dart';

typedef OnLastSectionValid = void Function();

class FormFooter extends StatelessWidget {
  final Logger logger = locator<Logger>();
  final FormBaseViewModel viewModel;

  /// Called to scroll the list back to the top after a successful section move.
  final VoidCallback onScrollToTop;

  /// Called with the index of the first invalid question after a failed Next.
  final ValueChanged<int> onScrollToInvalid;

  /// Called when the form reaches the last section and Next validates.
  final OnLastSectionValid? onLastSectionValid;

  FormFooter({
    required this.viewModel,
    required this.onScrollToTop,
    required this.onScrollToInvalid,
    this.onLastSectionValid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final canGoBack = viewModel.formStore.couldGoToPreviousSection;
        final isLastSection = !viewModel.formStore.couldGoToNextSection;
        return FormChromeFooter(
          canGoBack: canGoBack,
          isLastSection: isLastSection,
          isReviewing: false,
          onBack: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            if (viewModel.back() == BackAction.navigationPop) {
              logger.d("back using pop");
              await Navigator.maybePop(context);
            } else {
              logger.d("back but do nothing");
              onScrollToTop();
            }
          },
          onNext: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (!viewModel.next()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: incidentsErrorRed,
                  content: Text(
                    AppLocalizations.of(context)!.invalidFormValue,
                    style: const TextStyle(
                      fontFamily: incidentsFontFamily,
                      fontFamilyFallback: incidentsFontFamilyFallback,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(milliseconds: 1000),
                ),
              );
              onScrollToInvalid(viewModel.firstInvalidQuestionIndex);
            } else {
              onScrollToTop();
              if (onLastSectionValid != null &&
                  viewModel.state == ReportFormState.confirmation) {
                onLastSectionValid!.call();
              }
            }
          },
        );
      },
    );
  }
}
