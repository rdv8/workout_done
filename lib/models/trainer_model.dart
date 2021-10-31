class Trainer {
  final String id;
  final String? email;

  Trainer({
    required this.id,
    required this.email,
  });

  factory Trainer.empty() => Trainer(
        id: '',
        email: '',
      );
}
