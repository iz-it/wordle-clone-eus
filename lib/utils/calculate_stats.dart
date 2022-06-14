import 'package:shared_preferences/shared_preferences.dart';

calculateStats({required bool gameWon}) async {
  //inicializacion de variables para generar estadisticas de juego
  int JokuZenbakia = 0, //numero de juegos
      irabazitakoJokuak = 0, //juegos ganados
      irabazitakoEhunekoa = 0, //porcentaje ganados
      egungoMarra = 0, //racha
      gehiengoMarra = 0; //racha maxima

  final estatitikak = await getStats(); //estadisticas

  //guardado de estadisticas en array
  if (estatitikak != null) {
    JokuZenbakia = int.parse(estatitikak[0]);
    irabazitakoJokuak = int.parse(estatitikak[1]);
    irabazitakoEhunekoa = int.parse(estatitikak[2]);
    egungoMarra = int.parse(estatitikak[3]);
    gehiengoMarra = int.parse(estatitikak[4]);
  }
  //juego jugado se suma
  JokuZenbakia++;

  if (gameWon) { //si la palabra es correcta, se suma 1 a juegos jugados y racha
    irabazitakoJokuak++;
    egungoMarra++;
  } else { //si no se gana, la racha se reinicia
    egungoMarra = 0;
  }
  if (egungoMarra > gehiengoMarra) { //si la racha del dia supera a la estadistica de racha guardada
    //la estadistica guardada se convierte en el valor de racha del día
    gehiengoMarra = egungoMarra;
  }
  //calculo de porcentaje de victorias = juegos ganados dividido por juegos jugados *100
  irabazitakoEhunekoa = ((irabazitakoJokuak / JokuZenbakia) * 100).toInt();

  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList('stats', [
    JokuZenbakia.toString(),
    irabazitakoJokuak.toString(),
    irabazitakoEhunekoa.toString(),
    egungoMarra.toString(),
    gehiengoMarra.toString()
  ]);
}

Future<List<String>?> getStats() async {
  final prefs = await SharedPreferences.getInstance();
  final estatistikak = prefs.getStringList('estatistikak');
  if (estatistikak != null) {
    return estatistikak;
  } else {
    return null;
  }
}
