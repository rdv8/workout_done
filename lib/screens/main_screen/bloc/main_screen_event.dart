abstract class MainScreenEvent {
  MainScreenEvent();
}

class InitialMainScreenEvent extends MainScreenEvent {}

class AddWorkoutMainScreenEvent extends MainScreenEvent {
  String date;
  String clientId;
  String clientLastName;

  AddWorkoutMainScreenEvent({
    required this.date,
    required this.clientId,
    required this.clientLastName,
  });
}
