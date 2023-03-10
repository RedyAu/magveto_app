import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

class RoadCountWidget extends StatelessWidget {
  final Color color;
  final int? count;

  const RoadCountWidget({Key? key, required this.color, this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23,
      width: 18,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          image: DecorationImage(
            image: AssetImage('assets/other/road.png'),
            filterQuality: FilterQuality.medium,
            fit: BoxFit.fill,
          ),
        ),
        child: count != null
            ? FittedBox(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: BorderedText(
                    strokeWidth: 3,
                    strokeColor: Colors.black,
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 0.0),
                            color: Colors.black,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
