
List<Trainer> trainerList = [
  Trainer(id: '1', name: 'Di'),
  Trainer(id: '2', name: 'Ai'),
  Trainer(id: '3', name: 'Bi'),
  Trainer(id: '4', name: 'Ci'),
];

class Trainer {
  final String id;
  final String name;

  Trainer({required this.id, required this.name});
}

List<Client> clientList = [
  Client(trainerId: '1',id: '1',name: 'Client1',),
  Client(trainerId: '2',id: '2',name: 'Client2',isSplit: true),
  Client(trainerId: '2',id: '3',name: 'Client3',isDiscount: true),
  Client(trainerId: '3',id: '4',name: 'Client4',isKid: true,),
  Client(trainerId: '4',id: '5',name: 'Client5',),
];

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