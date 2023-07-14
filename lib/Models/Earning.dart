// To parse this JSON data, do
//
//     final earning = earningFromJson(jsonString);

import 'dart:convert';

Earning earningFromJson(String str) => Earning.fromJson(json.decode(str));

String earningToJson(Earning data) => json.encode(data.toJson());

class Earning {
  Earning({
    this.earn,
  });

  Earn? earn;

  factory Earning.fromJson(Map<String, dynamic> json) => Earning(
    earn: Earn.fromJson(json),
  );

  Map<String, dynamic> toJson() => {
    "Earn": earn?.toJson(),
  };
}

class Earn {
  Earn({
    this.graphData,
    this.total,
  });

  List<GraphDatum>? graphData;
  String? total;

  factory Earn.fromJson(Map<String, dynamic> json) => Earn(
    graphData: List<GraphDatum>.from(json["graph_data"].map((x) => GraphDatum.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "graph_data": List<dynamic>.from(graphData!.map((x) => x.toJson())),
    "total": total,
  };
}

class GraphDatum {
  GraphDatum({
    this.earning,
    this.months,
  });

  String? earning;
  String? months;

  factory GraphDatum.fromJson(Map<String, dynamic> json) => GraphDatum(
    earning: json["earning"],
    months: json["months"],
  );

  Map<String, dynamic> toJson() => {
    "earning": earning,
    "months": months,
  };
}
