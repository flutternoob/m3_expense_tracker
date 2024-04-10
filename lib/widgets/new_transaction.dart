import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m3_expense_tracker/widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction(this.addTx, {Key? key}) : super(key: key) {
    print("Constructor New transaction widget");
  }

  final Function addTx;

  @override
  State<NewTransaction> createState() {
    print("createState() New transaction widget");
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {

  _NewTransactionState() {
    print("Constructor transaction state");
  }

  @override
  void initState() {
    super.initState();
    print("initState()");
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget()");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose()");
  }

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  DateTime? _selectedDate;

  void _submitData() {
    final String enteredTitle = _titleController.text;
    final double enteredAmount = double.parse(_amountController.text);

    if (_amountController.text.isEmpty) {
      return;
    }

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(enteredTitle, enteredAmount, _selectedDate);

    Navigator.pop(context);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                  onSubmitted: (_) => _submitData(),
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount"),
                  onSubmitted: (_) => _submitData(),
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_selectedDate == null
                            ? "No date chosen"
                            : "PickedDate: ${DateFormat.yMd().format(_selectedDate!)}"),
                      ),
                      AdaptiveFlatButton("Choose date", _presentDatePicker)
                    ],
                  ),
                ),
                RaisedButton(
                  color: themeData.primaryColor,
                  onPressed: _submitData,
                  child: const Text("Add transaction"),
                  textColor: themeData.textTheme.button!.color,
                )
              ],
            ),
          )),
    );
  }
}
