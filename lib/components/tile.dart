import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordleidinaf/constants/answer_stages.dart';

import '../constants/colors.dart';
import '../providers/controller.dart';

class Cuadrado extends StatefulWidget {
  const Cuadrado({
    required this.index,
    Key? key,
  }) : super(key: key);

  final int index;

  @override
  State<Cuadrado> createState() => _CuadradoState();
}

class _CuadradoState extends State<Cuadrado> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  Color _backgroundColor = Colors.transparent,
        _borderColor = Colors.transparent;
  late procesoRespuesta _procesoRespuesta;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _borderColor = Theme.of(context).primaryColorLight;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (_, notifier, __) {
      String text = "";
      Color fontColor = Colors.white;
      if (widget.index < notifier.cuadradosUsados.length) {

        text = notifier.cuadradosUsados[widget.index].letter;

        _procesoRespuesta = notifier.cuadradosUsados[widget.index].estadoRespuesta;
        if (notifier.checkFila) {
          final delay = widget.index - (notifier.filaActual - 1) * 5;
          Future.delayed(Duration(milliseconds: 300 * delay), () {
            if (mounted) {
              _animationController.forward();
            }
            notifier.checkFila = false;
          });

          _backgroundColor = Theme.of(context).primaryColorLight;
          if (_procesoRespuesta == procesoRespuesta.correcto) {
            _backgroundColor = correctGreen;
          } else if (_procesoRespuesta == procesoRespuesta.contains) {
            _backgroundColor = containsYellow;
          } else if (_procesoRespuesta == procesoRespuesta.incorrecto) {
            _backgroundColor = Theme.of(context).primaryColorDark;
          } else {
            fontColor =
                Theme.of(context).textTheme.bodyText2?.color ?? Colors.black;
            _backgroundColor = Colors.transparent;
          }
        }

        return AnimatedBuilder(
          animation: _animationController,
          builder: (_, child) {
            double flip = 0;
            if (_animationController.value > 0.50) {
              flip = pi;
            }
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.003)
                ..rotateX(_animationController.value * pi)
                ..rotateX(flip),
              child: Container(
                  decoration: BoxDecoration(
                      color: flip > 0 ? _backgroundColor : Colors.transparent,
                      border: Border.all(
                        color: flip > 0 ? Colors.transparent : _borderColor,
                      )),
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: flip > 0
                              ? Text(
                                  text,
                                  style: const TextStyle()
                                      .copyWith(color: fontColor),
                                )
                              : Text(text)))),
            );
          },
        );
      } else {
        return Container(
          decoration: BoxDecoration(
              color: _backgroundColor,
              border: Border.all(
                color: _borderColor,
              )),
        );
      }
    });
  }
}
