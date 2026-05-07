import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podd_app/l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podd_app/app_theme.dart';
import 'package:podd_app/components/flat_button.dart';
import 'package:podd_app/components/language_dropdown.dart';
import 'package:podd_app/components/restart_widget.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/ui/forgot_password/reset_password_request_view.dart';
import 'package:podd_app/ui/login/login_view_model.dart';
import 'package:podd_app/ui/login/qr_login_view.dart';
import 'package:podd_app/ui/register/register_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.55, 1.0],
              colors: [
                Color(0xFF1F4148),
                Color(0xFF2A2F37),
                Color(0xFF14171C),
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: -100,
                left: -80,
                child: IgnorePointer(
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0x4000ADB5),
                          Color(0x0000ADB5),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Center(
                  child: _LoginForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) {
    return LoginViewModel();
  }
}

class _LoginForm extends StackedHookView<LoginViewModel> {
  @override
  Widget builder(BuildContext context, LoginViewModel viewModel) {
    final AppTheme appTheme = locator<AppTheme>();
    var username = useTextEditingController();
    var password = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
          alignment: Alignment.center,
          child: SizedBox(
              width: 240.w, child: Image.asset('assets/images/logo.png')),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: appTheme.bg2,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign in',
                            style: TextStyle(
                              fontFamily: appTheme.font,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              color: appTheme.sub1,
                              height: 1.1,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            viewModel.subDomain.isEmpty
                                ? 'Pick a server to continue'
                                : 'Connected to ${_serverLabel(viewModel)}',
                            style: TextStyle(
                              fontFamily: appTheme.font,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: appTheme.sub2,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150.w,
                      child: _languageDropdown(viewModel, context),
                    ),
                    const SizedBox(height: 10),
                    _tenantDropdown(viewModel, context),
                    const SizedBox(height: 20),
                    ...skipIfDomainNotSelected(viewModel, [
                      TextField(
                        controller: username,
                        textInputAction: TextInputAction.next,
                        onChanged: viewModel.setUsername,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.usernameLabel,
                          errorText: viewModel.error("username"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: password,
                        textInputAction: TextInputAction.done,
                        obscureText: viewModel.obscureText,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.passwordLabel,
                          errorText: viewModel.error("password"),
                          suffixIcon: IconButton(
                            onPressed: () {
                              viewModel.setObscureText(!viewModel.obscureText);
                            },
                            hoverColor: Colors.transparent,
                            icon: viewModel.obscureText
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                        onChanged: viewModel.setPassword,
                        onSubmitted: (value) {
                          viewModel.setPassword(value);
                          viewModel.authenticate();
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: -10,
                              right: 2,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ResetPasswordRequestView(),
                                    ),
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .forgotPasswordButton,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (viewModel.hasErrorForKey("general"))
                        Text(
                          viewModel.error("general"),
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton.primary(
                          onPressed:
                              viewModel.isBusy ? null : viewModel.authenticate,
                          child: viewModel.isBusy
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  AppLocalizations.of(context)!.loginButton,
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _qrcodeLogin(context),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton.outline(
                          backgroundColor: appTheme.bg2,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterView(),
                              ),
                            );
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.grid_view_outlined, size: 16.w),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.of(context)!.registerButton,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () => context.go('/login-v2'),
                          child: Text(
                            '(preview) Sign in v2 →',
                            style: TextStyle(
                              fontFamily: appTheme.font,
                              fontSize: 12.sp,
                              color: appTheme.sub2,
                            ),
                          ),
                        ),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  skipIfDomainNotSelected<T>(LoginViewModel viewModel, List<T> items) {
    if (viewModel.subDomain == "") {
      return <T>[];
    }

    return items;
  }

  String _serverLabel(LoginViewModel viewModel) {
    final match = viewModel.serverOptions.firstWhere(
      (o) => o['domain'] == viewModel.subDomain,
      orElse: () => <String, String>{'label': ''},
    );
    return match['label'] ?? '';
  }

  Widget _qrcodeLogin(
    BuildContext context,
  ) {
    final AppTheme appTheme = locator<AppTheme>();
    return SizedBox(
      width: double.infinity,
      child: FlatButton.outline(
        backgroundColor: appTheme.bg2,
        onPressed: () async {
          var error = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (context) => const QrLoginView(),
            ),
          );
          if (error != null) {
            if (context.mounted) {
              showAlert(context, error);
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 16.w),
            const SizedBox(width: 4),
            Text(
              AppLocalizations.of(context)!.qrCodeLoginButton,
              style: TextStyle(fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }

  showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Scan Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _tenantDropdown(LoginViewModel viewModel, BuildContext context) {
    if (viewModel.busy("tenants")) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(),
      );
    }

    final AppTheme appTheme = locator<AppTheme>();
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: appTheme.sub3),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: appTheme.primary, width: 1.6),
        ),
        labelText: AppLocalizations.of(context)!.serverLabel,
      ),
      hint: const Text("Server"),
      initialValue: viewModel.subDomain,
      onChanged: (String? value) async {
        if (value == null) {
          return;
        }
        await viewModel.changeServer(value);
        if (context.mounted) {
          RestartWidget.restartApp(context);
        }
      },
      items: viewModel.serverOptions
          .map<DropdownMenuItem<String>>((option) => DropdownMenuItem(
                value: option["domain"],
                child: Text(option['label'] ?? ""),
              ))
          .toList(),
    );
  }

  Widget _languageDropdown(LoginViewModel viewModel, BuildContext context) {
    if (viewModel.busy("tenants")) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of(context)!.loading,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    return LanguageDropdown(
      value: viewModel.language,
      onChanged: (String? value) async {
        await viewModel.changeLanguage(value ?? "en");
        if (context.mounted) {
          RestartWidget.restartApp(context);
        }
      },
    );
  }
}
