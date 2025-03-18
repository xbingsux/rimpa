class RedeemQRModel {
  final String status;
  final String token;
  final DateTime issuedAt;
  final DateTime expiresAt;

  RedeemQRModel({
    required this.status,
    required this.token,
    required this.issuedAt,
    required this.expiresAt,
  });

  factory RedeemQRModel.fromJson(Map<String, dynamic> json) {
    return RedeemQRModel(
      status: json['status'],
      token: json['token'],
      issuedAt: DateTime.fromMillisecondsSinceEpoch(json['iat'] * 1000),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(json['exp'] * 1000),
    );
  }
}
