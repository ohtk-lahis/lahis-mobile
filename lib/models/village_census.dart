import 'package:podd_app/models/animal_species.dart';
import 'package:podd_app/models/operation_exception_failure.dart';
import 'package:podd_app/models/village.dart';

class AnimalCensusFactInput {
  final int speciesId;
  final int animalQuantity;
  final int householdQuantity;

  const AnimalCensusFactInput({
    required this.speciesId,
    required this.animalQuantity,
    required this.householdQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'speciesId': speciesId,
      'animalQuantity': animalQuantity,
      'householdQuantity': householdQuantity,
    };
  }
}

class AnimalCensusFact {
  final AnimalSpecies species;
  final int animalQuantity;
  final int householdQuantity;

  const AnimalCensusFact({
    required this.species,
    required this.animalQuantity,
    required this.householdQuantity,
  });

  factory AnimalCensusFact.fromJson(Map<String, dynamic> json) =>
      AnimalCensusFact(
        species: AnimalSpecies.fromJson(json['species']),
        animalQuantity: json['animalQuantity'] as int? ?? 0,
        householdQuantity: json['householdQuantity'] as int? ?? 0,
      );
}

class VillageCensusSnapshot {
  final int id;
  final Village? village;
  final DateTime? censusDate;
  final String? submittedAt;
  final int? definitionVersionId;
  final int? definitionVersionNumber;
  final List<AnimalCensusFact> facts;
  final Map<String, dynamic> formData;

  const VillageCensusSnapshot({
    required this.id,
    this.village,
    this.censusDate,
    this.submittedAt,
    this.definitionVersionId,
    this.definitionVersionNumber,
    this.facts = const [],
    this.formData = const {},
  });

  factory VillageCensusSnapshot.fromJson(Map<String, dynamic> json) {
    final definitionVersion = json['definitionVersion'] is Map
        ? Map<String, dynamic>.from(json['definitionVersion'] as Map)
        : const <String, dynamic>{};
    return VillageCensusSnapshot(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      village:
          json['village'] != null ? Village.fromJson(json['village']) : null,
      censusDate: json['censusDate'] != null
          ? DateTime.tryParse(json['censusDate'].toString())
          : null,
      submittedAt: json['submittedAt']?.toString(),
      definitionVersionId: _parseInt(definitionVersion['id']),
      definitionVersionNumber: _parseInt(definitionVersion['version']),
      facts: (json['facts'] as List? ?? const [])
          .map((fact) => AnimalCensusFact.fromJson(fact))
          .toList(),
      formData: Map<String, dynamic>.from(json['formData'] as Map? ?? {}),
    );
  }
}

class VillageCensusDraft {
  final int villageId;
  final String kind;
  final int? definitionVersionId;
  final Map<String, Map<String, String>> measureValues;
  final DateTime savedAt;

  const VillageCensusDraft({
    required this.villageId,
    required this.kind,
    required this.measureValues,
    required this.savedAt,
    this.definitionVersionId,
  });

  factory VillageCensusDraft.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, String>> parseMeasureValues(dynamic value) {
      final rows = value as Map? ?? const {};
      return rows.map(
        (rowKey, measures) => MapEntry(
          rowKey.toString(),
          (measures as Map? ?? const {}).map(
            (measureKey, measureValue) => MapEntry(
              measureKey.toString(),
              measureValue?.toString() ?? '',
            ),
          ),
        ),
      );
    }

    return VillageCensusDraft(
      villageId: json['villageId'] is int
          ? json['villageId'] as int
          : int.parse('${json['villageId']}'),
      kind: json['kind']?.toString() ?? '',
      definitionVersionId: _parseInt(json['definitionVersionId']),
      measureValues: parseMeasureValues(json['measureValues']),
      savedAt: DateTime.tryParse(json['savedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'villageId': villageId,
      'kind': kind,
      'definitionVersionId': definitionVersionId,
      'measureValues': measureValues,
      'savedAt': savedAt.toIso8601String(),
    };
  }
}

abstract class VillageCensusSubmitResult {}

class VillageCensusSubmitSuccess extends VillageCensusSubmitResult {
  final VillageCensusSnapshot snapshot;

  VillageCensusSubmitSuccess(this.snapshot);
}

class VillageCensusSubmitFailure extends OperationExceptionFailure
    implements VillageCensusSubmitResult {
  VillageCensusSubmitFailure(super.e);
}

class VillageCensusSubmitValidationFailure extends VillageCensusSubmitResult {
  final List<String> messages;

  VillageCensusSubmitValidationFailure(this.messages);
}

class VillageCensusSubmitUnsupported extends VillageCensusSubmitResult {}

class CensusDefinitionChanged extends VillageCensusSubmitResult {
  final List<String> messages;

  CensusDefinitionChanged(this.messages);
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
