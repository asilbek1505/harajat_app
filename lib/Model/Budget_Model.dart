class Budget {
  final String month; // masalan: "2025-05"
  final int amount;

  Budget({required this.month, required this.amount});

  Map<String, dynamic> toMap() {
    return {'month': month, 'amount': amount};
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      month: map['month'],
      amount: map['amount'],
    );
  }
}
