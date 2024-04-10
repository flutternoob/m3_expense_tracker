import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:m3_expense_tracker/widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: "Quicksand",
        textTheme: const TextTheme(
            headline5: TextStyle(
                fontFamily: "OpenSans",
                fontSize: 18,
                fontWeight: FontWeight.bold),
            button: TextStyle(color: Colors.white)),
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: "OpenSans",
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  final List<Transaction> _userTransactions = [
    /*Transaction(id: "T1", title: "New shoes", amount: 69.99, date: DateTime.now()),
    Transaction(id: "T2", title: "Weekly groceries", amount: 16.53, date: DateTime.now()),*/
  ];

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final Transaction newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  List<Transaction>? get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date!.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  bool _showChart = false;

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, Function materialAppBar, txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Show Chart",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (bool value) {
              setState(() => _showChart = value);
            },
          )
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                  _preferredSize(context, _startAddNewTransaction) -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(
                recentTransactions: _userTransactions,
              ),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, Function materialAppBar, txListWidget) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
            _preferredSize(context, _startAddNewTransaction) -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(
          recentTransactions: _userTransactions,
        ),
      ),
      txListWidget
    ];
  }

  CupertinoNavigationBar _cupertinoNavigationBar(BuildContext context, Function _startAddNewTransaction) {
    return CupertinoNavigationBar(
      middle: const Text("Personal expenses"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _startAddNewTransaction(context),
            child: const Icon(CupertinoIcons.add),
          )
        ],
      ),
    );
  }

  AppBar _materialAppBar(BuildContext context, Function _startAddNewTransaction) {
    return AppBar(title: const Text("Personal Expenses"), actions: [
      IconButton(
        onPressed: () => _startAddNewTransaction(context),
        icon: const Icon(Icons.add),
      )
    ]);
  }

  num _preferredSize (BuildContext context, Function _startAddNewTransaction) {
    return AppBar(title: const Text("Personal Expenses"), actions: [
      IconButton(
        onPressed: () => _startAddNewTransaction(context),
        icon: const Icon(Icons.add),
      )
    ]).preferredSize.height;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final SizedBox txListWidget = SizedBox(
      height: (mediaQuery.size.height -
              _preferredSize(context, _startAddNewTransaction) -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final Widget pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape) ...[
              ..._buildLandscapeContent(mediaQuery, _materialAppBar, txListWidget)
            ],
            if (!isLandscape) ...[
              ..._buildPortraitContent(mediaQuery, _materialAppBar, txListWidget)
            ],
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: _cupertinoNavigationBar(context, _startAddNewTransaction),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: _materialAppBar(context, _startAddNewTransaction),
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? null
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
