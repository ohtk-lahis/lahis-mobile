import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podd_app/components/brand_logo.dart';
import 'package:podd_app/components/restart_widget.dart';
import 'package:podd_app/l10n/app_localizations.dart';
import 'package:podd_app/theme/ohtk_style_system.dart';
import 'package:podd_app/ui/login/login_view_model.dart';
import 'package:podd_app/ui/login/picker_sheets.dart';
import 'package:podd_app/ui/login/qr_login_view.dart';
import 'package:podd_app/ui/register/register_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

Color get _tealHero => OhtkTheme.palette.teal700;
Color get _tealMid => OhtkTheme.palette.teal800;
Color get _tealDeep => OhtkTheme.palette.teal900;
Color get _sand => OhtkColor.cream;
Color get _ink => OhtkColor.ink900;
Color get _muted => OhtkColor.ink500;
Color get _hair => OhtkColor.line;
Color get _placeholder => OhtkColor.ink300;
const _fontFamily = OhtkType.family;
const _fontFamilyFallback = OhtkType.fallback;

/// Overflow-safe login across phone sizes, large text, and keyboard.
///
/// ```
/// LayoutBuilder
/// └── Column
///     ├── Expanded(_Hero)   // logo scales to remaining height (FittedBox)
///     └── ConstrainedBox    // sheet ≤ remaining, hug content; ListView shrinkWrap
///         └── sheet form    // scrolls only when content exceeds cap
/// ```
class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    final media = MediaQuery.of(context);
    final clamped = media.copyWith(
      textScaler: media.textScaler.clamp(
        minScaleFactor: 1.0,
        maxScaleFactor: 1.35,
      ),
    );

    return MediaQuery(
      data: clamped,
      child: Scaffold(
        backgroundColor: _tealDeep,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalH = constraints.maxHeight;
              // Always leave a usable hero band; sheet may scroll under the cap.
              final sheetMax = math.max(
                200.0,
                math.min(totalH * 0.58, totalH - 168.0),
              );

              return Column(
                children: [
                  Expanded(child: _Hero(viewModel: viewModel)),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: sheetMax),
                    child: _ReturningSheet(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

double _logoTileForHeight(double heroHeight) {
  const chrome = 120.0;
  final budget = math.max(0.0, heroHeight - chrome);
  if (budget >= 200) return 136;
  if (budget >= 170) return 120;
  if (budget >= 140) return 100;
  if (budget >= 110) return 84;
  return 72;
}

class _Hero extends StatelessWidget {
  final LoginViewModel viewModel;
  const _Hero({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.55, -0.9),
          radius: 1.35,
          colors: [_tealHero, _tealMid, _tealDeep],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tile = _logoTileForHeight(constraints.maxHeight);
            final framePad = tile >= 120 ? 11.0 : 8.0;
            final outerR = tile >= 120 ? 38.0 : (tile >= 100 ? 32.0 : 26.0);
            final innerR = tile >= 120 ? 24.0 : (tile >= 100 ? 20.0 : 16.0);
            final compact = constraints.maxHeight < 280;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                compact ? 2 : 4,
                24,
                compact ? 12 : 16,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: _LanguagePill(viewModel: viewModel),
                  ),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: BrandLogo(
                          outerRadius: outerR,
                          innerRadius: innerR,
                          tileSize: tile,
                          framePadding: framePad,
                        ),
                      ),
                    ),
                  ),
                  _RegisterCta(compact: compact),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final LoginViewModel viewModel;
  const _LanguagePill({required this.viewModel});

  void _openLanguageSheet(BuildContext context) {
    LanguagePickerSheet.show(
      context,
      currentLanguage: viewModel.language,
      onPicked: (code) async {
        if (code == viewModel.language) {
          Navigator.of(context).pop();
          return;
        }
        await viewModel.changeLanguage(code);
        if (!context.mounted) return;
        Navigator.of(context).pop();
        if (!context.mounted) return;
        RestartWidget.restartApp(context);
      },
    );
  }

  String _languageLabel(String code) {
    switch (code) {
      case 'th':
        return 'ไทย';
      case 'en':
        return 'EN';
      case 'lo':
        return 'ລາວ';
      case 'km':
        return 'ខ្មែរ';
      case 'fr':
        return 'FR';
      case 'es':
        return 'ES';
      case 'my':
        return 'မြန်မာ';
      default:
        return code.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => _openLanguageSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                _languageLabel(viewModel.language),
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontFamilyFallback: _fontFamilyFallback,
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterCta extends StatelessWidget {
  final bool compact;
  const _RegisterCta({this.compact = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vPad = compact ? 12.0 : 15.0;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RegisterView()),
          );
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: vPad),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  l10n.signInRegisterCta,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontFamilyFallback: _fontFamilyFallback,
                    color: _tealDeep,
                    fontSize: compact ? 14 : 15,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: _tealDeep, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReturningSheet extends StackedHookView<LoginViewModel> {
  @override
  Widget builder(BuildContext context, LoginViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    final username = useTextEditingController();
    final password = useTextEditingController();

    // shrinkWrap ListView: height = content, up to parent maxHeight; then scrolls.
    return Material(
      color: _sand,
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: SafeArea(
        top: false,
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _hair,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.signInReturningEyebrow.toUpperCase(),
              style: TextStyle(
                fontFamily: _fontFamily,
                fontFamilyFallback: _fontFamilyFallback,
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            _TextFieldShell(
              icon: Icons.person_outline_rounded,
              controller: username,
              hint: l10n.usernameLabel,
              errorText: viewModel.error('username'),
              obscure: false,
              onChanged: viewModel.setUsername,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            _TextFieldShell(
              icon: Icons.lock_outline_rounded,
              controller: password,
              hint: l10n.passwordLabel,
              errorText: viewModel.error('password'),
              obscure: viewModel.obscureText,
              onChanged: viewModel.setPassword,
              onSubmitted: (value) {
                viewModel.setPassword(value);
                viewModel.authenticate();
              },
              textInputAction: TextInputAction.done,
              trailing: IconButton(
                tooltip: 'Toggle password visibility',
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  viewModel.obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _muted,
                  size: 20,
                ),
                onPressed: () =>
                    viewModel.setObscureText(!viewModel.obscureText),
              ),
            ),
            if (viewModel.hasErrorForKey('general')) ...[
              const SizedBox(height: 8),
              Text(
                viewModel.error('general'),
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontFamilyFallback: _fontFamilyFallback,
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 14),
            _SignInButton(viewModel: viewModel, l10n: l10n),
            const SizedBox(height: 4),
            _QrSignInButton(),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _ServerFooter(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}

class _TextFieldShell extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final bool obscure;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction textInputAction;
  final Widget? trailing;

  const _TextFieldShell({
    required this.icon,
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.textInputAction,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: hasError ? Colors.red.shade300 : _hair,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            children: [
              Icon(icon, color: _muted, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  textInputAction: textInputAction,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontFamilyFallback: _fontFamilyFallback,
                    color: _ink,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontFamily: _fontFamily,
                      fontFamilyFallback: _fontFamilyFallback,
                      color: _placeholder,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                fontFamily: _fontFamily,
                fontFamilyFallback: _fontFamilyFallback,
                color: Colors.red,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SignInButton extends StatelessWidget {
  final LoginViewModel viewModel;
  final AppLocalizations l10n;
  const _SignInButton({required this.viewModel, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: viewModel.isBusy ? null : viewModel.authenticate,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.disabled)
                  ? _tealHero.withValues(alpha: 0.55)
                  : _tealHero),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        child: viewModel.isBusy
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.4,
                ),
              )
            : Text(
                l10n.signInButton,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontFamilyFallback: _fontFamilyFallback,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class _QrSignInButton extends StatelessWidget {
  Future<void> _openQr(BuildContext context) async {
    final error = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrLoginView()),
    );
    if (error != null && context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Scan Error'),
          content: Text(error),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: _tealHero),
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextButton.icon(
      onPressed: () => _openQr(context),
      style: TextButton.styleFrom(
        foregroundColor: _tealHero,
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      icon: const Icon(Icons.qr_code_2_rounded, size: 18),
      label: Text(
        l10n.signInQrCodeButton,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFamilyFallback,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ServerFooter extends StatelessWidget {
  final LoginViewModel viewModel;
  const _ServerFooter({required this.viewModel});

  String _serverLabel() {
    final match = viewModel.serverOptions.firstWhere(
      (o) => o['domain'] == viewModel.subDomain,
      orElse: () => <String, String>{'label': viewModel.subDomain},
    );
    return match['label'] ?? viewModel.subDomain;
  }

  void _openServerSheet(BuildContext context) {
    final selectableServers = viewModel.serverOptions
        .where((o) => (o['domain'] ?? '').isNotEmpty)
        .toList();
    ServerPickerSheet.show(
      context,
      currentServerDomain: viewModel.subDomain,
      servers: selectableServers,
      onConfirmed: (domain) async {
        await viewModel.changeServer(domain);
        if (!context.mounted) return;
        Navigator.of(context).pop();
        if (!context.mounted) return;
        RestartWidget.restartApp(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Icon(Icons.cloud_outlined, size: 15, color: _muted),
        const SizedBox(width: 6),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontFamily: _fontFamily,
                fontFamilyFallback: _fontFamilyFallback,
                color: _muted,
                fontSize: 12,
              ),
              children: [
                TextSpan(text: '${l10n.signInServerLabel}: '),
                TextSpan(
                  text: _serverLabel(),
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontFamilyFallback: _fontFamilyFallback,
                    color: _ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () => _openServerSheet(context),
          style: TextButton.styleFrom(
            foregroundColor: _tealHero,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          child: Text(
            l10n.signInChangeServerButton,
            style: const TextStyle(
              fontFamily: _fontFamily,
              fontFamilyFallback: _fontFamilyFallback,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
