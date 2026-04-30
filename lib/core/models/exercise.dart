class Exercise {
  final String id;
  final String? externalId;
  final String source;
  final String name;
  final String bodyPart;
  final String targetPrimary;
  final String equipment;
  final String? gifUrl;
  final String? muscleGroup;

  const Exercise({
    required this.id,
    this.externalId,
    required this.source,
    required this.name,
    required this.bodyPart,
    required this.targetPrimary,
    required this.equipment,
    this.gifUrl,
    this.muscleGroup,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: 'exercisedb_${json['id'] as String}',
        externalId: json['id'] as String,
        source: 'exercisedb',
        name: json['name'] as String,
        bodyPart: json['bodyPart'] as String,
        targetPrimary: json['target'] as String,
        muscleGroup: json['target'] as String?,
        equipment: json['equipment'] as String,
        gifUrl: json['gifUrl'] as String?,
      );
}
