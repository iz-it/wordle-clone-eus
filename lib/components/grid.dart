import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordleidinaf/animations/bounce.dart';
import 'package:wordleidinaf/components/tile.dart';

import '../animations/dance.dart';
import '../providers/controller.dart';

class Grid extends StatefulWidget {
  const Grid({
    Key? key,
  }) : super(key: key);

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(36, 20, 36, 20),
        itemCount: 30,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          crossAxisCount: 5,
        ),
        itemBuilder: (context, index) {
          return Consumer<Controller>(
            builder: (_, notifier, __) {
              bool animate = false;
              bool animateDance = false;
              int danceDelay = 1600;
              if (index == (notifier.cuadradoActual - 1) &&
                  !notifier.pulsa_borrarEnter) {
                animate = true;
              }
              if (notifier.juegoGanado) {
                for (int i = notifier.cuadradosUsados.length - 5;
                    i < notifier.cuadradosUsados.length;
                    i++) {
                  if (index == i) {
                    animateDance = true;
                    danceDelay += 150 * (i - ((notifier.filaActual - 1) * 5));
                  }
                }
              }
              return Dance(
                delay: danceDelay,
                animate: animateDance,
                child: Bounce(
                    animate: animate,
                    child: Cuadrado(
                      index: index,
                    )),
              );
            },
          );
        });
  }
}
