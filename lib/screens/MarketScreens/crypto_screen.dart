import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class CryptoCurrenPage extends StatelessWidget {
  static String tag = '/CryptoCurrenPage';

  final String apiURL =
      "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=5000&convert=USD";

  Future<List<dynamic>> fetchCryptoData() async {
    var response = await http.get(Uri.parse(apiURL), headers: {
      'X-CMC_PRO_API_KEY': '257bcb4c-5bc8-411f-ada5-a2b854ec66df',
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      print("Response = 200");
    }
    return json.decode(response.body)['data'];
  }

  String _cryptosymbol(dynamic crypto) {
    return crypto['symbol'];
  }

  String _cryptoname(dynamic crypto) {
    return crypto['name'];
  }

  _cryptoprice(dynamic crypto) {
    return crypto['quote']['USD']['price'].toStringAsFixed(2);
  }

  _cryptopercent(dynamic crypto) {
    return crypto['quote']['USD']['percent_change_1h'].toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 42),
        child: FutureBuilder<List<dynamic>>(
            future: fetchCryptoData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print("Data Available!");
                // print(_price(snapshot.data[0]));
                // print(_symbol(snapshot.data[0]));
                return ListView.builder(
                    padding: EdgeInsets.all(3),
                    itemCount: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 9.0),
                              Text(
                                _cryptoname(snapshot.data[index]),
                                style: secondaryTextStyle(size: 15),
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                _cryptosymbol(snapshot.data[index]),
                                style: secondaryTextStyle(size: 12),
                              ),

                              // const SizedBox(
                              //   height: 6,
                              // )
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 9.0),
                              Text(
                                '\$ ${_cryptoprice(snapshot.data[index])}',
                                style: secondaryTextStyle(size: 16),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                '${_cryptopercent(snapshot.data[index])}% 1h',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: double.parse(_cryptopercent(
                                              snapshot.data[index])) >
                                          0
                                      ? Colors.lightGreen
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                print("Data Unavailable!");
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
