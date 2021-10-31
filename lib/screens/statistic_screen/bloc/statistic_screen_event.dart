abstract class StatisticScreenEvent {}

class InitialStatisticScreenEvent extends StatisticScreenEvent {
  final DateTime date;

  InitialStatisticScreenEvent({required this.date});
}