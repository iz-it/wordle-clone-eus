import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordleidinaf/constants/answer_stages.dart';
import 'package:wordleidinaf/constants/colors.dart';

import '../providers/controller.dart';
import '../data/keys_map.dart';

class KeyboardRow extends StatelessWidget {
  const KeyboardRow({
    required this.min,
    required this.max,
    Key? key,
  }) : super(key: key);

  final int min, max;

  @override
  Widget build(BuildContext context) {
    //MediaQuery size = tamano de pantalla de dispositivo
    final size = MediaQuery.of(context).size;

    return Consumer<Controller>(
      builder: (_, notifier, __) {
        int index = 0;
        return IgnorePointer(
          ignoring: notifier.finJuego,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //numeracion de letras del array keysmap
            children: keysMap.entries.map((e) {
              index++;
              //numero +1 = siguiente letra
              //1=a, 2=b, 3=c... etc
              if (index >= min && index <= max) {
                //valor min max = primer cuadrado / ultimo cuadrado de fila correspondiente
                Color color = Theme.of(context).primaryColorLight;
                Color keyColor = Colors.white;
                //asignacion de color a teclas
                if (e.value == procesoRespuesta.correcto) {
                  color = correctGreen;
                } else if (e.value == procesoRespuesta.contains) {
                  color = containsYellow;
                } else if (e.value == procesoRespuesta.incorrecto) {
                  color = Theme.of(context).primaryColorDark;
                } else {
                  keyColor = Theme.of(context).textTheme.bodyText2?.color ??
                      Colors.black;
                }

                return Padding(
                    //espacio entre teclas
                    padding: EdgeInsets.all(size.width * 0.006),
                    //rectangulo con esquinas redondeadas
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          //operacion condicional ternario =
                          //si es true (la tecla es enter o borrar), el tamaño sera 0.13
                          //si es false el tamaño será menor
                          width: e.key == 'ENTER' || e.key == 'BACK'
                              ? size.width * 0.13
                              : size.width * 0.085,
                          //misma altura para teclas
                          height: size.height * 0.09,
                          child: Material(
                            color: color,
                            child: InkWell(
                                onTap: () {
                                  //listen sera false aqui porque no importa el valor
                                  //importa que ha avanzado 1 casilla
                                  Provider.of<Controller>(context,
                                          listen: false)
                                      .setKeyTapped(value: e.key);
                                },
                                child: Center(
                                  child: e.key == 'BACK'
                                      ? const Icon(Icons.backspace_outlined)
                                      : Text(
                                          e.key,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(
                                                color: keyColor,
                                              ),
                                        ),
                                )),
                          ),
                        )));
              } else {
                return const SizedBox();
              }
            }).toList(),
          ),
        );
      },
    );
  }
}
