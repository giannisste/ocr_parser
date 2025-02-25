class CosmoteDocument {
  const CosmoteDocument({
    required this.rfCode,
    required this.paymentAmount,
    required this.dueDate,
    required this.holderName,
    required this.holderAddress,
  });
  
  final String rfCode;
  final double paymentAmount;
  final DateTime? dueDate;

  final String holderName;
  final String holderAddress;

}
