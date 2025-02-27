class ListReward {
  final int id;
  final String rewardName;
  final String description;
  final String img;
  final DateTime startDate;
  final DateTime endDate;
  final String cost;
  final String paymentType;
  final int stock;
  final int? maxPerUser;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool active;

  ListReward({
    required this.id,
    required this.rewardName,
    required this.description,
    required this.img,
    required this.startDate,
    required this.endDate,
    required this.cost,
    required this.paymentType,
    required this.stock,
    this.maxPerUser,
    required this.createdAt,
    required this.updatedAt,
    required this.active,
  });

  factory ListReward.fromJson(Map<String, dynamic> json) {
    return ListReward(
      id: json['id'],
      rewardName: json['reward_name'],
      description: json['description'],
      img: json['img'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      cost: json['cost'],
      paymentType: json['paymentType'],
      stock: json['stock'],
      maxPerUser: json['max_per_user'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      active: json['active'],
    );
  }
}
