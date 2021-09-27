
var constTrainerId = '3E6yJqTTIJEPUB77v6OE';

class Client {
  String trainerId;
  String id;
  String name;
  bool isSplit;
  bool isKid;
  bool isDiscount;

  Client({
    required this.trainerId,
    required this.id,
    required this.name,
    this.isSplit = false,
    this.isDiscount = false,
    this.isKid = false,
  });
}

List<WorkOut> workoutList = [
  WorkOut(id: '1', trainerId: '1', clientId: '1', date: DateTime(2021,09,14)),
  WorkOut(id: '2', trainerId: '2', clientId: '2', date: DateTime(2021,09,14)),
  WorkOut(id: '3', trainerId: '1', clientId: '3', date: DateTime(2021,09,15)),
  WorkOut(id: '4', trainerId: '3', clientId: '1', date: DateTime(2021,09,14)),
  WorkOut(id: '5', trainerId: '2', clientId: '5', date: DateTime(2021,09,16)),
  WorkOut(id: '6', trainerId: '4', clientId: '4', date: DateTime(2021,09,14)),
  WorkOut(id: '7', trainerId: '3', clientId: '3', date: DateTime(2021,09,15)),
  WorkOut(id: '8', trainerId: '4', clientId: '1', date: DateTime(2021,09,16)),
  WorkOut(id: '9', trainerId: '2', clientId: '2', date: DateTime(2021,09,14)),
  WorkOut(id: '10', trainerId: '3', clientId: '4', date: DateTime(2021,09,15)),

];

class WorkOut {
  String id;
  String trainerId;
  String clientId;
  DateTime date;
  WorkOut({required this.id, required this.trainerId, required this.clientId, required this.date});
}