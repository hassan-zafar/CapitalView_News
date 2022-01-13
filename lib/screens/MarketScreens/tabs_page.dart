import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mighty_news/screens/MarketScreens/chart.dart';
import 'package:mighty_news/screens/MarketScreens/crypto_screen.dart';

class TabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Crypto'),
              ),
              Tab(
                child: Text('Stock'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [CryptoCurrenPage(), WatchList()],
        ),
      ),
    );
  }
}
