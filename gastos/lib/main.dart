import 'dart:io'; // Platform

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Orientation
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import '../models/transaction.dart';

// Ctrl + Espacio para mostrar opciones disponible en el lugar donde se encuentra el puntero

// Refactorizar: Doble click seleccionado + Alt + Enter se muestran opciones
// Responsive: contenido adaptable a orientacion veritical horizontal
// Adaptive: widget adaptable a la plataforma destino android ios
// MediaQuery: recupera informacion sobre el dispositivo, orientacion, medidas, configuracion usuario...
// LayoutBuilder: define restricciones para aplicar al widget

// Container: takes exactly one child widget, rich alignment & styling options,
// flexible width, perfect for custom styling & alignment

// Column / Row: takes unlimited child widgets, alignment but no styling options,
// always takes full available height column / width row, must use if widgets sit
// next to above each other

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gastos Personales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // collection of different color shades
        accentColor: Colors.amber,
        //errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // combinacion de estilo definida para toda la aplicacion
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'Cena',
    //   amount: 70.88,
    //   date: DateTime.now(), // hora actual
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Zapatos',
    //   amount: 85.99,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  // recoger transacciones con menos de 7 dias
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate, // argumento : valor
      id: DateTime.now().toString(),
    );

    // se puede llamar al metodo porque la clase extiende de State
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  // empezar el proceso para una nueva transaccion
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior
              .opaque, // ocultar hoja input al tocar fuera de ella
        );
      },
    ); // builder context solo si es necesario para el objeto interno
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Gastos Personales',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Gastos Personales',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    // debug iOS
    print(appBar.preferredSize.height);

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // used to arrange children widgets into vertically format according to given axis
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // determines how Row and Column can position their children on their cross axes
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Mostrar Grafica',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Switch.adaptive(
                    // boton para habilitar visualizacion grafica
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            // centrar boton inferior
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
