class DeiDocument {
  const DeiDocument({
    required this.dueDate, 
    required this.rfCode,
    required this.paymentAmount,
    required this.address,
    
  });

  final String rfCode;
  final double paymentAmount;
  final String address;
  final DateTime? dueDate;
}
