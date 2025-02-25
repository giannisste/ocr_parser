class NovaDocument {
  const NovaDocument({
    required this.paymentAmount,
    required this.dueDate,
    required this.rfCode,
    required this.holderName,
    required this.holderAddress,
  });

  final double paymentAmount;
  final DateTime? dueDate;
  final String rfCode;

  final String holderName;
  final String holderAddress;
}
