class Workout {
  String? id;
  String trainerId;
  String clientId;
  String clientLastName;
  String date;

  Workout({
    this.id,
    required this.trainerId,
    required this.clientId,
    required this.clientLastName,
    required this.date,
  });

  factory Workout.empty() => Workout(
        id: '',
        trainerId: '',
        clientId: '',
        clientLastName: '',
        date: '',
      );
}
