class WorkoutModel {
  final String? id;
  final String trainerId;
  final String clientId;
  final String clientLastName;
  final bool isDiscount;
  final bool isSplit;
  final bool isTeenage;
  final int day;
  final int month;
  final int year;

  WorkoutModel({
    this.id,
    required this.trainerId,
    required this.clientId,
    required this.clientLastName,
    required this.day,
    required this.month,
    required this.year,
    required this.isSplit,
    required this.isDiscount,
    required this.isTeenage,
  });

  factory WorkoutModel.empty() => WorkoutModel(
        isSplit: false,
        isDiscount: false,
        isTeenage: false,
        id: '',
        trainerId: '',
        clientId: '',
        clientLastName: '',
        day: 0,
        month: 0,
        year: 0,
      );
}
