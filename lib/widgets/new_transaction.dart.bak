import 'dart:io'; // Platform

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // expresion ternaria

// statefulwidget (datos persistentes) porque de lo contrario en la entrada de datos se elimina el valor al cambiar de Textfield
class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // almacenar puntero en la funcion
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  // añadir transaccion
  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    // usuario no introduce dato o es negativo
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return; // termina la ejecucion de la funcion submitData
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    // cerrar la pantalla superior mostrada, context accesible por extender de State
    Navigator.of(context).pop();
  }

  // input seleccionar fecha
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedData) {
      // fecha seleccionada por el usuario
      if (pickedData == null) {
        return;
      }
      setState(() {
        // trigger disparador para avisar ejecutar compilacion de nuevo
        _selectedDate = pickedData;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // input, teclado virtual, permite hacer scroll
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                10, // viewInsets teclado virtual
          ),
          // apuntar cada lado directamente
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                // user input
                decoration: InputDecoration(labelText: 'Titulo'),
                controller: _titleController,
                onSubmitted: (_) =>
                    _submitData(), // submitData lleva parentesis por ser funcion anonima dentro del cuerpo, descargar el valor aqui para utilizar la funcion sin argumentos
                //onChanged: (val) { // listener, con el controller no es necesario hacerlo manual
                //titleInput = val;
                //},
              ),
              // descripcion dentro textfield
              TextField(
                // user input
                decoration: InputDecoration(labelText: 'Cantidad'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) =>
                    _submitData(), // anonymous function (_) recibe argumento que no se va a utilizar => expresion, ; semicolon
                //onChanged: (val) => amountInput = val,
              ),
              Container(
                // mostrar fecha seleccionada en container input
                height: 70,
                child: Row(children: <Widget>[
                  Expanded(
                    // ocupar maximo espacio libre disponible
                    child: Text(
                      _selectedDate == null
                          ? 'No hay datos seleccionados!'
                          : 'Fecha Seleccionada: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  Platform.isIOS
                      ? CupertinoButton(
                          color: Colors.blue,
                          child: Text(
                            'Selecciona Fecha',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _presentDatePicker,
                        )
                      : FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            'Selecciona Fecha',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _presentDatePicker,
                        ),
                ]),
              ),
              RaisedButton(
                child: Text('Añadir Transacción'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed:
                    _submitData, // submitData sin parentesis porque onPressed no es funcion anonima
              ),
            ],
          ),
        ),
      ),
    );
  }
}
