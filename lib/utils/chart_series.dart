import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordleidinaf/models/chart_model.dart';

Future<List<charts.Series<ChartModel, String>>> getSeries() async {
  List<ChartModel> data = [];
  final prefs = await SharedPreferences.getInstance();
  final puntuak = prefs.getStringList('chart');
  final fila = prefs.getInt('fila');
  if (puntuak != null) {
    for (var e in puntuak) {
      data.add(ChartModel(puntuacion: int.parse(e), juegoActual: false));
    }
  }
  if (fila != null) {
    data[fila - 1].juegoActual = true;
  }

  return [
    charts.Series<ChartModel, String>(
        id: 'Estatistikak',
        data: data,
        domainFn: (model, index) {
          int i = index! + 1;
          return i.toString();
        },
        measureFn: (model, index) => model.puntuacion,
        colorFn: (model, index) {
          if (model.juegoActual) {
            return charts.MaterialPalette.green.shadeDefault;
          } else {
            return charts.MaterialPalette.gray.shadeDefault;
          }
        },
        labelAccessorFn: (model, index) => model.puntuacion.toString()),
    charts.Series<ChartModel, String>(
        id: 'Estatistikak',
        data: data,
        domainFn: (model, index) {
          int i = index! + 1;
          return i.toString();
        },
        measureFn: (model, index) => model.puntuacion,
        colorFn: (model, index) {
          if (model.juegoActual) {
            return charts.MaterialPalette.green.shadeDefault;
          } else {
            return charts.MaterialPalette.gray.shadeDefault;
          }
        },
        labelAccessorFn: (model, index) => model.puntuacion.toString()),
  ];
}
