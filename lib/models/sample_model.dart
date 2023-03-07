class SampleModel {
  final int id;
  final String data;

  // model constructor
  SampleModel({
    required this.id,
    required this.data,
  });

  // for converting from json (usually from api calls)
  factory SampleModel.fromJson(Map<String, dynamic> json) {
    return SampleModel(
      id: json['id'],
      data: json['data'],
    );
  }

  // for converting back to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data,
      };
}
