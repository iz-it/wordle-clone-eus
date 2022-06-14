import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordleidinaf/pages/settings.dart';
import 'package:wordleidinaf/utils/quick_box.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../components/stats_box.dart';
import '../constants/words.dart';
import '../providers/controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _palabra;

  @override
  void initState() {
    //variable r será la palabra aleatoria elegida del array de palabras
    final r = Random().nextInt(hitzak.length);
    _palabra = hitzak[r];

  //pasar informacion de palabra seleccionada al controlador
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<Controller>(context, listen: false)
          .setCorrectWord(word: _palabra);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //barra de titulo de app
      appBar: AppBar(
        title: const Text('Wordle EUS'),
        centerTitle: true,
        backgroundColor: Colors.green,
        //quita sombra entre el titulo y el body
        elevation: 0,
        actions: [
          Consumer<Controller>(
            builder: (_, notifier, __) {
              if (notifier.faltanLetras) {
                runQuickBox(context: context, message: 'Letrak falta dira');
              }
              if (notifier.finJuego) { //Notificacion de juego terminado
                if (notifier.juegoGanado) { //si gana
                  if (notifier.filaActual == 6) {//si gana en la ultima fila
                    //gana en la ultima oportunidad, mensaje que dice "por poco"
                    runQuickBox(context: context, message: 'Gutxigatik!');
                  } else {
                    //si es antes de la ultima fila, genial!
                    runQuickBox(context: context, message: 'Ederto!');
                  }
                } else {
                  //si no acierta le decimos cual era la palabra
                  runQuickBox(context: context, message: notifier.palabCorrecta);
                }
                Future.delayed(
                  const Duration(milliseconds: 4000),
                  () {
                    if (mounted) {
                      showDialog(
                          context: context, builder: (_) => const puntuLaukia());
                    }
                  },
                );
              }
              return IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context, builder: (_) => const puntuLaukia());
                  },
                  icon: const Icon(Icons.bar_chart_outlined));
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Settings()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          //crear fina linea - division entre titulo y body
          const Divider(
            height: 2,
            thickness: 5,
          ),

          //parte de pantalla que cogera el juego
          //clase grid - cuadrados con letras
          const Expanded(flex: 7, child: Grid()),
          //debajo de juego ponemos teclado
          Expanded(
            flex: 4, //tamano de teclado
            child: Column(
              children: const [
                KeyboardRow(
                  //min es primera letra, max es ultima letra
                  min: 1,
                  max: 10,
                ),
                KeyboardRow(
                  //min es primer cudrado de segunda fila, max es ultimo
                  min: 11,
                  max: 19,
                ),
                KeyboardRow(
                  min: 20,
                  max: 29,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
