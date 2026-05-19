import 'package:podd_app/models/animal_species.dart';

class CensusDefinitionVersion {
  final int id;
  final int version;
  final String status;
  final CensusRuntimeSchema runtimeSchema;

  const CensusDefinitionVersion({
    required this.id,
    required this.version,
    required this.status,
    required this.runtimeSchema,
  });

  factory CensusDefinitionVersion.fromJson(Map<String, dynamic> json) =>
      CensusDefinitionVersion(
        id: _parseInt(json['id']) ?? 0,
        version: _parseInt(json['version']) ?? 0,
        status: json['status']?.toString() ?? '',
        runtimeSchema: CensusRuntimeSchema.fromJson(
          Map<String, dynamic>.from(json['runtimeSchema'] as Map? ?? const {}),
        ),
      );
}

class CensusRuntimeSchema {
  final List<CensusSchemaRow> rows;
  final List<CensusSchemaMeasure> measures;
  final List<Map<String, dynamic>> extraDimensions;

  const CensusRuntimeSchema({
    required this.rows,
    required this.measures,
    this.extraDimensions = const [],
  });

  factory CensusRuntimeSchema.fromJson(Map<String, dynamic> json) =>
      CensusRuntimeSchema(
        rows: (json['rows'] as List? ?? const [])
            .whereType<Map>()
            .map((row) => CensusSchemaRow.fromJson(
                  Map<String, dynamic>.from(row),
                ))
            .toList(),
        measures: (json['measures'] as List? ?? const [])
            .whereType<Map>()
            .map((measure) => CensusSchemaMeasure.fromJson(
                  Map<String, dynamic>.from(measure),
                ))
            .toList(),
        extraDimensions: (json['extra_dimensions'] as List? ?? const [])
            .whereType<Map>()
            .map((dimension) => Map<String, dynamic>.from(dimension))
            .toList(),
      );

  bool get supportsLegacyAnimalSubmit {
    final measureKeys = measures.map((measure) => measure.key).toSet();
    final speciesIds = rows.map((row) => row.speciesId).whereType<int>();
    return rows.isNotEmpty &&
        extraDimensions.isEmpty &&
        rows.every((row) => row.speciesId != null) &&
        speciesIds.length == speciesIds.toSet().length &&
        measureKeys.length == 2 &&
        measureKeys.contains('animal_quantity') &&
        measureKeys.contains('household_quantity');
  }

  List<AnimalSpecies> toAnimalSpeciesRows() {
    return rows
        .where((row) => row.speciesId != null)
        .map(
          (row) => AnimalSpecies(
            id: row.speciesId!,
            code: row.speciesCode,
            name: row.label,
            active: true,
            sortOrder: row.sortOrder,
          ),
        )
        .toList();
  }
}

class CensusSchemaRow {
  final String rowKey;
  final String label;
  final int? speciesId;
  final String speciesCode;
  final int sortOrder;

  const CensusSchemaRow({
    required this.rowKey,
    required this.label,
    this.speciesId,
    this.speciesCode = '',
    this.sortOrder = 0,
  });

  factory CensusSchemaRow.fromJson(Map<String, dynamic> json) {
    final speciesCode = json['species_code']?.toString() ?? '';
    return CensusSchemaRow(
      rowKey: json['row_key']?.toString() ?? json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? speciesCode,
      speciesId: _parseInt(json['species_id']),
      speciesCode: speciesCode,
      sortOrder: _parseInt(json['sort_order']) ?? 0,
    );
  }
}

class CensusSchemaMeasure {
  final String key;
  final String label;
  final String type;
  final bool required;

  const CensusSchemaMeasure({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
  });

  factory CensusSchemaMeasure.fromJson(Map<String, dynamic> json) =>
      CensusSchemaMeasure(
        key: json['key']?.toString() ?? '',
        label: json['label']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        required: json['required'] as bool? ?? false,
      );
}

int? _parseInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  return int.tryParse(value.toString());
}
