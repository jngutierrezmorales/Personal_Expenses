import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No existen transacciones todavia!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  // espacio entre la imagen y el titulo
                  height: 20,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ))
                // fit ajustar tamaño imagen
              ],
            );
          })
        : ListView.builder(
            // .builder construye widgets cuando son requeridos
            itemBuilder: (ctx, index) {
              // contexto y indice del elemento de lista
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    // CircleAvatar reemplazable por container
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                          child: Text('${transactions[index].amount}€')),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? FlatButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text('Eliminar'),
                          textColor: Theme.of(context).errorColor,
                    onPressed: () => deleteTx(transactions[index]
                        .id),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () => deleteTx(transactions[index]
                              .id), // funcion anonima metodo delete recibe string
                        ),
                ),
              ); // diseño adaptable a listas
            },
            itemCount: transactions.length,
          );
  }
}
