class TrainerModel {
  final String id;
  final String? email;

  TrainerModel({
    required this.id,
    required this.email,
  });

  factory TrainerModel.empty() => TrainerModel(
        id: '',
        email: '',
      );
}
