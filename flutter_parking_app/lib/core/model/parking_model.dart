class ParkingModel {
  String id;
  String parkingName;
  String companyName;
  String country;
  String city;
  String street;
  int numOfSlots;
  int availableNumOfSlots;
  String image;
  final int index;

  ParkingModel(
      {this.id,
      this.parkingName,
      this.companyName,
      this.country,
      this.city,
      this.street,
      this.numOfSlots,
      this.availableNumOfSlots,
      this.image,
      this.index});

  factory ParkingModel.fromMap(map) {
    return ParkingModel(
      id: map['id'],
      parkingName: map['parkingName'],
      companyName: map['companyName'],
      country: map['country'],
      city: map['city'],
      street: map['street'],
      numOfSlots: map['numOfSlots'],
      availableNumOfSlots: map['availableNumOfSlots'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parkingName': parkingName,
      'companyName': companyName,
      'country': country,
      'city': city,
      'street': street,
      'numOfSlots': numOfSlots,
      'availableNumOfSlots': availableNumOfSlots,
      'image': image,
    };
  }
}
