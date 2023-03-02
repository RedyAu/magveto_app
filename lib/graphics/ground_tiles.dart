import 'package:flutter/material.dart';
import '../logic/index.dart';

class GroundTile extends StatelessWidget {
  final TileType tileType;

  const GroundTile(this.tileType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // hexagon shaped container
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: GroundTilePainter(tileType),
      ),
    );
  }
}

class GroundTilePainter extends CustomPainter {
  final TileType tileType;

  GroundTilePainter(this.tileType);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    switch (tileType) {
      case TileType.path:
        paint.color = Colors.grey;
        break;
      case TileType.rocky:
        paint.color = Colors.brown;
        break;
      case TileType.thorny:
        paint.color = Colors.green;
        break;
      case TileType.redeemed:
        paint.color = Colors.amber;
        break;
    }

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 4);
    path.lineTo(size.width, size.height * 3 / 4);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height * 3 / 4);
    path.lineTo(0, size.height / 4);
    path.lineTo(size.width / 2, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
