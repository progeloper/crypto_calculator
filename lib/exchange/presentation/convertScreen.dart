import 'dart:math';

import 'package:coin_repository/coin_repository.dart';
import 'package:crypto_calculator/exchange/cubit/exchange_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ConvertPage extends StatelessWidget {
  const ConvertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExchangeCubit(context.read<CoinRepository>()),
      child: ConvertView(),
    );
  }
}

class ConvertView extends StatefulWidget {
  const ConvertView({super.key});

  @override
  State<ConvertView> createState() => _ConvertViewState();
}

class _ConvertViewState extends State<ConvertView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  Widget _currentDate() {
    final currentDate = DateFormat.MMMMEEEEd().format(DateTime.now());
    return Text(
      currentDate,
      style: GoogleFonts.hindMadurai(
        textStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _netValueCircle(Widget child) {
    return CustomPaint(
      painter: ConcentricCircles(),
      child: Center(
        child: child,
      ),
    );
  }

  Widget _netValueGradientString(String text, String currency) {
    return Column(
      children: [
        GradientText(
          text: text,
          style: GoogleFonts.raleway(
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          currency,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _firstParagraph() {
    return Text(
      'Quickly search the current rates for the most popular cryptocurrencies',
      style: GoogleFonts.oxygen(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black54,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: _currentDate(),
            ),
            SizedBox(
              height: 80,
            ),
            _firstParagraph(),
            BlocBuilder<ExchangeCubit, ExchangeState>(
              builder: (context, state) {
                if (state.status == ExchangeStatus.loading) {
                  return _netValueCircle(
                    Container(
                      height: size.height * 0.2,
                      width: size.width * 0.3,
                      child: Lottie.asset(
                        'assets/loading_plane.json',
                        controller: animationController,
                        onLoaded: (composition) {
                          animationController
                            ..duration = composition.duration
                            ..forward()
                            ..repeat();
                        },
                      ),
                    ),
                  );
                } else if (state.status == ExchangeStatus.success) {
                  return _netValueCircle(
                    _netValueGradientString(
                        state.exchange.rate.toString(), state.exchange.quote),
                  );
                } else{
                  return _netValueCircle(
                    Container(
                      height: size.height * 0.2,
                      width: size.width * 0.3,
                      child: Lottie.asset(
                        'assets/error_animation.json',
                        controller: animationController,
                        onLoaded: (composition) {
                          animationController
                            ..duration = composition.duration
                            ..forward()
                            ..repeat();
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConcentricCircles extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width * 0.5;
    var centerY = size.height * 0.5;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var largeGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFBAC4E4), Color(0xFFF0EEFA)],
    );
    var midCircleGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFAF1F0), Color(0xFFB9B9C4)],
    );

    var largeCirclePaint = Paint()
      ..shader = largeGradient
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    var shadowCircle = Paint()
      ..shader = RadialGradient(
              colors: [Colors.white12, Colors.white.withOpacity(0.0)])
          .createShader(Rect.fromCircle(center: center, radius: radius));
    var midCirclePaint = Paint()
      ..shader = midCircleGradient
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    var smallCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, largeCirclePaint);
    canvas.drawCircle(center, radius * 0.77, shadowCircle);
    canvas.drawCircle(center, radius * 0.75, midCirclePaint);
    canvas.drawCircle(center, radius * 0.77, shadowCircle);
    canvas.drawCircle(center, radius * 0.65, smallCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class GradientText extends StatelessWidget {
  const GradientText({super.key, required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            Color(0xFF0D05F7),
            Color(0xFF05C3F7),
            Color(0xFF05F7B3),
          ],
        ).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
