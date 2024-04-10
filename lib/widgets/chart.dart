import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m3_expense_tracker/models/transaction.dart';
import 'package:m3_expense_tracker/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key, this.recentTransactions}) : super(key: key);

  final List<Transaction>? recentTransactions;

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final DateTime weekday = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (int i = 0; i < recentTransactions!.length; i++) {
        if (recentTransactions![i].date!.day == weekday.day &&
            recentTransactions![i].date!.month == weekday.month &&
            recentTransactions![i].date!.year == weekday.year) {
          totalSum += recentTransactions![i].amount!;
        }
      }
      return {"day": DateFormat.E().format(weekday), "amount": totalSum};
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + (item["amount"] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  (data["day"] as String),
                  (data["amount"] as double),
                  totalSpending == 0.0
                      ? 0.0
                      : (data["amount"] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
