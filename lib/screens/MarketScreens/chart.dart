import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WatchList extends StatelessWidget {
  final String apiUrl =
      "http://api.marketstack.com/v1/eod?access_key=apikey&symbols=AAPL,MSFT,FB,TSLA,INTC,CSCO,NVDA,MTU,WMT,KO,EBAY,MOT";
  // static Route<dynamic> route() => MaterialPageRoute(
  //       builder: (context) => WatchList(),
  //     );

  Future<List<dynamic>> fetchStockData() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['data'];
  }

  String _exchange(dynamic stats) {
    return stats['exchange'];
  }

  _open(dynamic stats) {
    return stats['open'].toString();
  }

  _high(dynamic stats) {
    return stats['high'].toString();
  }

  _low(dynamic stats) {
    return stats['low'].toString();
  }

  _volume(dynamic stats) {
    return stats['volume'].toString();
  }

  @override
  Widget build(BuildContext context) {
    final stocks = [
      {'name': 'Apple', 'id': 'AAPL'},
      {'name': 'Microsoft', 'id': 'MSFT'},
      {'name': 'Facebook', 'id': 'FB'},
      {'name': 'Tesla', 'id': 'TSLA'},
      {'name': 'Intel Corporation', 'id': 'INTC'},
      {'name': 'Cisco Systems, Inc.', 'id': 'CSCO'},
      {'name': 'NVIDIA Corporation', 'id': 'NVDA'},
      {'name': 'Mitsubishi', 'id': 'MTU'},
      {'name': 'Wal-Mart Stores, Inc.', 'id': 'WMT'},
      {'name': 'Coca-Cola Company', 'id': 'KO'},
      {'name': 'eBay, Inc.', 'id': 'EBAY'},
      {'name': 'Motorola, Inc.', 'id': 'MOT'},
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Chart"),
      // ),
      body: Container(
        padding: EdgeInsets.only(bottom: 42.0),
        child: FutureBuilder<List<dynamic>>(
          future: fetchStockData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print(_open(snapshot.data[0]));
              return ListView.builder(
                  padding: EdgeInsets.all(3),
                  itemCount: stocks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 9.0),
                            Text(
                              stocks[index]['id']!,
                              style: TextStyle(fontSize: 15.0),
                            ),
                            const SizedBox(height: 9.0),
                            Text(
                              stocks[index]['name']!,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Text(_exchange(snapshot.data[index])),
                        // trailing: FlatButton(
                        //   color: double.parse(_open(snapshot.data[0])) <
                        //           double.parse(_open(snapshot.data[1]))
                        //       ? Colors.red
                        //       : Colors.lightGreen,
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => ChartPage(
                        //                   stocks[index]['id'],
                        //                   stocks[index]['name'],
                        //                   _exchange(snapshot.data[index]),
                        //                   _open(snapshot.data[index]),
                        //                   _high(snapshot.data[index]),
                        //                   _low(snapshot.data[index]),
                        //                   _volume(snapshot.data[index]),
                        //                 )));
                        //   },
                        //   child: Text(
                        //     _open(snapshot.data[index]),
                        //   ),
                        // ),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
