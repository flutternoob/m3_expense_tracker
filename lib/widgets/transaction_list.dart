import 'package:flutter/material.dart';
import 'package:m3_expense_tracker/models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction>? transactions;

  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions!.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text(
                  "No transactions added as yet",
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView(
            children: transactions!
                .map(
                  (tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                      deleteTx: deleteTx),
                )
                .toList(),
          );
  }
}
