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
  final List<AnimalCensusFact> facts;

  const VillageCensusSnapshot({
    required this.id,
    this.village,
    this.censusDate,
    this.submittedAt,
    this.facts = const [],
  });

  factory VillageCensusSnapshot.fromJson(Map<String, dynamic> json) =>
      VillageCensusSnapshot(
        id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
        village:
            json['village'] != null ? Village.fromJson(json['village']) : null,
        censusDate: json['censusDate'] != null
            ? DateTime.tryParse(json['censusDate'].toString())
            : null,
        submittedAt: json['submittedAt']?.toString(),
        facts: (json['facts'] as List? ?? const [])
            .map((fact) => AnimalCensusFact.fromJson(fact))
            .toList(),
      );
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
