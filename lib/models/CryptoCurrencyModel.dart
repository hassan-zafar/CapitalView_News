class CryptoCurrencyModel {
  CurrencyDataModel? data;
  Status? status;

  CryptoCurrencyModel({this.data, this.status});

  factory CryptoCurrencyModel.fromJson(Map<String, dynamic> json) {
    return CryptoCurrencyModel(
      data: json['data'] != null ? CurrencyDataModel.fromJson(json['data']) : null,
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    return data;
  }
}

class Status {
  int? credit_count;
  int? elapsed;
  int? error_code;
  String? error_message;
  String? notice;
  String? timestamp;

  Status({this.credit_count, this.elapsed, this.error_code, this.error_message, this.notice, this.timestamp});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      credit_count: json['credit_count'],
      elapsed: json['elapsed'],
      error_code: json['error_code'],
      error_message: json['error_message'],
      notice: json['notice'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_count'] = this.credit_count;
    data['elapsed'] = this.elapsed;
    data['error_code'] = this.error_code;
    data['error_message'] = this.error_message;
    data['notice'] = this.notice;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class CurrencyDataModel {
  List<CurrencyModel>? btc;
  List<CurrencyModel>? eth;

  CurrencyDataModel({this.btc, this.eth});

  factory CurrencyDataModel.fromJson(Map<String, dynamic> json) {
    return CurrencyDataModel(
      btc: json['BTC'] != null ? (json['BTC'] as List).map((i) => CurrencyModel.fromJson(i)).toList() : null,
      eth: json['ETH'] != null ? (json['ETH'] as List).map((i) => CurrencyModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.btc != null) {
      data['BTC'] = this.btc!.map((v) => v.toJson()).toList();
    }
    if (this.eth != null) {
      data['ETH'] = this.eth!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencyModel {
  int? id;
  String? name;
  String? slug;
  String? symbol;
  Quote? quote;

  CurrencyModel({
    this.id,
    this.name,
    this.slug,
    this.symbol,
    this.quote,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      symbol: json['symbol'],
      quote: json['quote'] != null ? Quote.fromJson(json['quote']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['symbol'] = this.symbol;
    if (this.quote != null) {
      data['quote'] = this.quote!.toJson();
    }
    return data;
  }
}

class Quote {
  USD? usd;

  Quote({this.usd});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      usd: json['USD'] != null ? USD.fromJson(json['USD']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.usd != null) {
      data['USD'] = this.usd!.toJson();
    }
    return data;
  }
}

class USD {
  double? price;
  double? percent_change_24h;

  USD({
    this.price,
    this.percent_change_24h,
  });

  factory USD.fromJson(Map<String, dynamic> json) {
    return USD(
      price: json['price'],
      percent_change_24h: json['percent_change_24h'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['percent_change_24h'] = this.percent_change_24h;
    return data;
  }
}
