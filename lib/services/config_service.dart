class ConfigService {
  String get graphqlEndpoint => const String.fromEnvironment('GRAPHQL_ENDPOINT',
      defaultValue: 'https://opensur.test/graphql/');

  String get tenantApiEndpoint =>
      const String.fromEnvironment('TENANT_API_ENDPOINT',
          defaultValue: "https://opensur.test/api/servers/");

  String get consentConfigurationKey =>
      const String.fromEnvironment('CONSENT_CONFIGURATION_KEY',
          defaultValue: "mobile.consent.msg");

  String get consentAcceptTextKey =>
      const String.fromEnvironment('CONSENT_ACCEPT_TEXT_KEY',
          defaultValue: "mobile.consent.accept.msg");

  /// When value is truthy, gender is required on registration.
  /// Key missing / false → optional (safe default for non-FAO tenants).
  /// Must use the `mobile.` prefix so the public `configurations` query returns it.
  String get registerGenderRequiredKey =>
      const String.fromEnvironment('REGISTER_GENDER_REQUIRED_KEY',
          defaultValue: "mobile.register.gender.required");

  /// When value is truthy, age is required on registration.
  /// Key missing / false → optional.
  String get registerAgeRequiredKey =>
      const String.fromEnvironment('REGISTER_AGE_REQUIRED_KEY',
          defaultValue: "mobile.register.age.required");

  /// Treat common enable values as true. Missing or empty → false.
  static bool isTruthyConfig(String? value) {
    if (value == null) return false;
    final normalized = value.trim().toLowerCase();
    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'enable' ||
        normalized == 'enabled';
  }
}
