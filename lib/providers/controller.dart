import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordleidinaf/constants/answer_stages.dart';
import 'package:wordleidinaf/models/tile_model.dart';
import 'package:wordleidinaf/utils/calculate_chart_stats.dart';

import '../utils/calculate_stats.dart';
import '../data/keys_map.dart';

class Controller extends ChangeNotifier {
  bool checkFila = false,
      pulsa_borrarEnter = false,
      juegoGanado = false,
      finJuego = false,
      faltanLetras = false;
  String palabCorrecta = "";
  int cuadradoActual = 0, filaActual = 0;
  List<wCuadrado> cuadradosUsados = [];

  //eleccion aleatoria de palabra se convierte en palabra a adivinar
  setCorrectWord({required String word}) => palabCorrecta = word;

  setKeyTapped({required String value}) {
    //usuario pulsa enter
    if (value == 'ENTER') {
      pulsa_borrarEnter = true;
      //si esta en ultimo cuadrado llama a metodo
      if (cuadradoActual == 5 * (filaActual + 1)) {
        checkWord();
        //si faltan cuadrados - aviso
      } else {
        faltanLetras = true;
      }
      //usuario pulsa borrar
    } else if (value == 'BACK') {
      pulsa_borrarEnter = true;
      faltanLetras = false;
      //si hay alguna letra escrita, se borra 1
      if (cuadradoActual > 5 * (filaActual + 1) - 5) {
        cuadradoActual--;
        cuadradosUsados.removeLast();
      }
      //si la tecla pulsada es otra
    } else {
      pulsa_borrarEnter = false;
      faltanLetras = false;
      //se suma la letra escrita y pasamos a siguiente cuadrado
      if (cuadradoActual < 5 * (filaActual + 1)) {
        cuadradosUsados.add(
            wCuadrado(letter: value, estadoRespuesta: procesoRespuesta.sinRespuesta));
        cuadradoActual++;
      }
    }
    //objeto ha cambiado y se notifica a todos los listeners
    notifyListeners();
  }

  checkWord() {
    List<String> asmatuta = [], remainingCorrect = [];
    String guessedWord = "";
    //check cada fila
    for (int i = filaActual * 5; i < (filaActual * 5) + 5; i++) {
      asmatuta.add(cuadradosUsados[i].letter);
    }

    guessedWord = asmatuta.join();
    remainingCorrect = palabCorrecta.characters.toList();

    if (guessedWord == palabCorrecta) {
      for (int i = filaActual * 5; i < (filaActual * 5) + 5; i++) {
        cuadradosUsados[i].estadoRespuesta = procesoRespuesta.correcto;
        //actualiza el valor del campo y proceso de respuesta
        keysMap.update(cuadradosUsados[i].letter, (value) => procesoRespuesta.correcto);
        juegoGanado = true;
        finJuego = true;
      }
    } else {
      for (int i = 0; i < 5; i++) {
        //palabra incorrecta pero letras coinciden en posiciones
        if (guessedWord[i] == palabCorrecta[i]) {
          //eliminar letra de grupo de letras correctas
          remainingCorrect.remove(guessedWord[i]);
          cuadradosUsados[i + (filaActual * 5)].estadoRespuesta = procesoRespuesta.correcto;
          //actualizar campo con valor correcto
          keysMap.update(guessedWord[i], (value) => procesoRespuesta.correcto);
        }
      }
      //recorrer array de letras correctas por adivinar
      for (int i = 0; i < remainingCorrect.length; i++) {
        //nested for recorrer fila actual letra por letra
        for (int j = 0; j < 5; j++) {
          if (remainingCorrect[i] ==
              cuadradosUsados[j + (filaActual * 5)].letter) {
            //entra en if solo si no está marcado como correcto
            if (cuadradosUsados[j + (filaActual * 5)].estadoRespuesta !=
                procesoRespuesta.correcto) {
              //si no es correcto pero contiene letra
              cuadradosUsados[j + (filaActual * 5)].estadoRespuesta =
                  procesoRespuesta.contains;
            }

            final resultKey = keysMap.entries.where((element) =>
                element.key == cuadradosUsados[j + (filaActual * 5)].letter);
            //contiene letra pero no en la posicion adecuada
            if (resultKey.single.value != procesoRespuesta.correcto) {
              keysMap.update(
                  resultKey.single.key, (value) => procesoRespuesta.contains);
            }
          }
        }
      }
      /*si despues de entrar en loops anteriores la respuesta no es
      * correcta ni "contains", será incorrecto*/
      for (int i = filaActual * 5; i < (filaActual * 5) + 5; i++) {
        if (cuadradosUsados[i].estadoRespuesta == procesoRespuesta.sinRespuesta) {
          cuadradosUsados[i].estadoRespuesta = procesoRespuesta.incorrecto;

          final results = keysMap.entries
              .where((element) => element.key == cuadradosUsados[i].letter);
          //arreglo de error: keys verde/amarillo se sobreescribian con gris
          if (results.single.value == procesoRespuesta.sinRespuesta) {
            keysMap.update(
                cuadradosUsados[i].letter, (value) => procesoRespuesta.incorrecto);
          }
        }
      }
    }
    checkFila = true;
    filaActual++;

    //si se llega a la ultima fila el juego termina
    if (filaActual == 6) {
      finJuego = true;
    }

    if (finJuego) {
      calculateStats(gameWon: juegoGanado);
      //si se acierta la palabra y se gana el juego
      if (juegoGanado) {
        //guardar estadistica de la fila
        setChartStats(currentRow: filaActual);
      }
    }
    //objeto ha cambiado y se notifica a todos los listeners
    notifyListeners();
  }
}
