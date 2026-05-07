import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podd_app/l10n/app_localizations.dart';
import 'package:podd_app/ui/login/login_view_model.dart';
import 'package:podd_app/ui/login/qr_login_view.dart';
import 'package:podd_app/ui/register/register_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

const _tealHero = Color(0xFF0F8A82);
const _tealMid = Color(0xFF0A5F5A);
const _tealDeep = Color(0xFF08423F);
const _sand = Color(0xFFF7F5F1);
const _ink = Color(0xFF1A1F1D);
const _muted = Color(0xFF6B7370);
const _hair = Color(0xFFE4E2DC);
const _placeholder = Color(0xFFA8ACA7);
const _fontFamily = 'NotoSansThai';

class LoginViewV2 extends StackedView<LoginViewModel> {
  const LoginViewV2({Key? key}) : super(key: key);

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: _tealDeep,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).viewInsets.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  _Hero(viewModel: viewModel),
                  Transform.translate(
                    offset: const Offset(0, -16),
                    child: _ReturningSheet(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final LoginViewModel viewModel;
  const _Hero({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.6, -1),
          radius: 1.4,
          colors: [_tealHero, _tealMid, _tealDeep],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 60,
              child: IgnorePointer(
                child: SizedBox(
                  height: 60,
                  child: CustomPaint(
                    painter: _ConnectedDotsPainter(),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _LanguagePill(viewModel: viewModel),
                  ],
                ),
                const SizedBox(height: 28),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 28),
                _RegisterCta(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final LoginViewModel viewModel;
  const _LanguagePill({required this.viewModel});

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
        onTap: () {
          // TODO: open language bottom sheet (next commit)
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
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
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.18),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RegisterView(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.registerButton,
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  color: _tealDeep,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward, color: _tealDeep, size: 18),
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

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _sand,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000), // ~6% black
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          const SizedBox(height: 12),
          const Text(
            'RETURNING REPORTER',
            style: TextStyle(
              fontFamily: _fontFamily,
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          _TextFieldShell(
            icon: Icons.person_outline,
            controller: username,
            hint: l10n.usernameLabel,
            errorText: viewModel.error('username'),
            obscure: false,
            onChanged: viewModel.setUsername,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          _TextFieldShell(
            icon: Icons.lock_outline,
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
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 14),
          _SignInButton(viewModel: viewModel, l10n: l10n),
          const SizedBox(height: 10),
          _QrSignInButton(),
          const SizedBox(height: 16),
          _ServerFooter(viewModel: viewModel),
        ],
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
              color: hasError ? Colors.red : _hair,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _ink,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontFamily: _fontFamily,
                      color: _placeholder,
                      fontSize: 14,
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
      child: ElevatedButton(
        onPressed: viewModel.isBusy ? null : viewModel.authenticate,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.disabled)
                  ? _tealHero.withValues(alpha: 0.6)
                  : _tealHero),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 14),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                l10n.loginButton,
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class _QrSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
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
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: _hair, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code_scanner, color: _tealHero, size: 18),
                const SizedBox(width: 8),
                Text(
                  l10n.qrCodeLoginButton,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _hair, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  color: _muted,
                  fontSize: 11,
                ),
                children: [
                  const TextSpan(text: 'Server: '),
                  TextSpan(
                    text: _serverLabel(),
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      color: _ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                // TODO: open server bottom sheet (next commit)
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  'Change ›',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    color: _tealHero,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectedDotsPainter extends CustomPainter {
  static const _dots = <List<double>>[
    [40, 20, 3],
    [100, 40, 2],
    [180, 15, 2.5],
    [260, 35, 3],
    [320, 20, 2],
  ];

  static const _lines = <List<int>>[
    [0, 1],
    [1, 2],
    [2, 3],
    [3, 4],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 360.0;
    final fill = Paint()..color = Colors.white.withValues(alpha: 0.15);
    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 0.6;

    for (final line in _lines) {
      final a = _dots[line[0]];
      final b = _dots[line[1]];
      canvas.drawLine(
        Offset(a[0] * scale, a[1]),
        Offset(b[0] * scale, b[1]),
        stroke,
      );
    }

    for (final dot in _dots) {
      canvas.drawCircle(Offset(dot[0] * scale, dot[1]), dot[2], fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
