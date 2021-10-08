///DTO Data Transfer Object
class ClientModel {
  final String? id;
  final String lastname;
  final String name;
  final bool isSplit;
  final bool isTeenage;
  final bool isDiscount;
  final bool? isHide;


  ClientModel({
    this.id,
    this.isHide,
    required this.lastname,
    required this.name,
    required this.isSplit,
    required this.isTeenage,
    required this.isDiscount,
  });

  factory ClientModel.empty() => ClientModel(
   isDiscount: false,
    isTeenage: false,
    isSplit: false,
    isHide: false,
    name: '',
    lastname: '',
    id: ''
  );
}