import 'package:flutter/material.dart';

class Drags extends StatefulWidget {
  @override
  _DragsState createState() => _DragsState();
}

class _DragsState extends State<Drags> {
  List<String> listA = ["A", "B", "C"];
  List<String> listB = ["D", "E", "F"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent[200],
      body: SafeArea(
        child: Column(
          children: [
//            list view separated will build a widget between 2 list items to act as a separator
            Expanded(
              child: ListView.separated(
                itemBuilder: _buildListAItems,
                separatorBuilder: _buildDragTargetsA,
                itemCount: listA.length,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: _buildListBItems,
                separatorBuilder: _buildDragTargetsB,
                itemCount: listB.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

//  builds the widgets for List B items
  Widget _buildListBItems(BuildContext context, int index) {
    return Draggable<String>(
//      the value of this draggable is set using data
      data: listB[index],
//      the widget to show under the users finger being dragged
      feedback: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listB[index],
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
//      what to display in the child's position when being dragged
      childWhenDragging: Container(
        color: Colors.grey,
        width: 40,
        height: 40,
      ),
//      widget in idle state
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listB[index],
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

//  builds the widgets for List A items
  Widget _buildListAItems(BuildContext context, int index) {
    return Draggable<String>(
      data: listA[index],
      feedback: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listA[index],
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
      childWhenDragging: Container(
        color: Colors.grey,
        width: 40,
        height: 40,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listA[index],
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

//  will return a widget used as an indicator for the drop position
  Widget _buildDropPreview(BuildContext context, String value) {
    return Card(
      color: Colors.lightBlue[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

//  builds DragTargets used as separators between list items/widgets for list A
  Widget _buildDragTargetsA(BuildContext context, int index) {
    return DragTarget<String>(
//      builder responsible to build a widget based on whether there is an item being dropped or not
      builder: (context, candidates, rejects) {
        return candidates.isNotEmpty
            ? _buildDropPreview(context, candidates[0]!)
            : const SizedBox(
                width: 5,
                height: 5,
              );
      },
//      condition on to accept the item or not
      onWillAccept: (value) => !listA.contains(value),
//      what to do when an item is accepted
      onAccept: (value) {
        setState(() {
          listA.insert(index + 1, value);
          listB.remove(value);
        });
      },
    );
  }

//  builds drag targets for list B
  Widget _buildDragTargetsB(BuildContext context, int index) {
    return DragTarget<String>(
      builder: (context, candidates, rejects) {
        return candidates.isNotEmpty
            ? _buildDropPreview(context, candidates[0]!)
            : const SizedBox(
                width: 5,
                height: 5,
              );
      },
      onWillAccept: (value) => !listB.contains(value),
      onAccept: (value) {
        setState(() {
          listB.insert(index + 1, value);
          listA.remove(value);
        });
      },
    );
  }
}

class CircleAvatarWithTransition extends StatelessWidget {
  /// the base color of the images background and its concentric circles.
  final Color primaryColor;

  /// the profile image to be displayed.
  final ImageProvider image;

  ///the diameter of the entire widget, including the concentric circles.
  final double size;

  /// the width between the edges of each concentric circle.
  final double transitionBorderwidth;

  const CircleAvatarWithTransition({
    Key? key,
    required this.primaryColor,
    required this.image,
    this.size = 190.0,
    this.transitionBorderwidth = 20.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor.withOpacity(0.05),
          ),
        ),
        Container(
          height: size - transitionBorderwidth,
          width: size - transitionBorderwidth,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              stops: const [0.01, 0.5],
              colors: [Colors.white, primaryColor.withOpacity(0.1)],
            ),
          ),
        ),
        Container(
          height: size - (transitionBorderwidth * 2),
          width: size - (transitionBorderwidth * 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor.withOpacity(0.4),
          ),
        ),
        Container(
          height: size - (transitionBorderwidth * 3),
          width: size - (transitionBorderwidth * 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor.withOpacity(0.5),
          ),
        ),
        Container(
          height: size - (transitionBorderwidth * 4),
          width: size - (transitionBorderwidth * 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(fit: BoxFit.cover, image: image),
          ),
        )
      ],
    );
  }
}
// import 'package:vector_math/vector_math_64.dart' as vector;

// class LoadingAnimatedButton extends StatefulWidget {
//   final Duration duration;
//   final Widget child;
//   final Function() onTap;
//   final double width;
//   final double height;

//   final Color color;
//   final double borderRadius;
//   final Color borderColor;
//   final double borderWidth;

//   const LoadingAnimatedButton(
//       {Key? key,
//       required this.child,
//       required this.onTap,
//       this.width = 200,
//       this.height = 50,
//       this.color = Colors.indigo,
//       this.borderColor = Colors.white,
//       this.borderRadius = 15.0,
//       this.borderWidth = 3.0,
//       this.duration = const Duration(milliseconds: 1500)})
//       : super(key: key);

//   @override
//   State<LoadingAnimatedButton> createState() => _LoadingAnimatedButtonState();
// }

// class _LoadingAnimatedButtonState extends State<LoadingAnimatedButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController =
//         AnimationController(vsync: this, duration: widget.duration);
//     _animationController.repeat();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: widget.onTap,
//       borderRadius: BorderRadius.circular(
//         widget.borderRadius,
//       ),
//       splashColor: widget.color,
//       child: CustomPaint(
//         painter: LoadingPainter(
//             animation: _animationController,
//             borderColor: widget.borderColor,
//             borderRadius: widget.borderRadius,
//             borderWidth: widget.borderWidth,
//             color: widget.color),
//         child: Container(
//           width: widget.width,
//           height: widget.height,
//           alignment: Alignment.center,
//           child: Padding(
//             padding: const EdgeInsets.all(5.5),
//             child: widget.child,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoadingPainter extends CustomPainter {
//   final Animation animation;
//   final Color color;
//   final double borderRadius;
//   final Color borderColor;
//   final double borderWidth;

//   LoadingPainter(
//       {required this.animation,
//       this.color = Colors.orange,
//       this.borderColor = Colors.white,
//       this.borderRadius = 15.0,
//       this.borderWidth = 3.0,})
//       : super(repaint: animation);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Offset.zero & size;
//     final paint = Paint()
//       ..shader = SweepGradient(
//               colors: [
//                 color.withOpacity(.25),
//                 color,
//               ],
//               // startAngle: 0.0,
//               endAngle: vector.radians(180),
//               stops: const [.75, 1.0],
//               transform:
//                   GradientRotation(vector.radians(360.0 * animation.value!)))
//           .createShader(rect);

//     final path = Path.combine(
//         PathOperation.xor,
//         Path()
//           ..addRRect(
//               RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),),
//         Path()
//           ..addRRect(RRect.fromRectAndRadius(
//               rect.deflate(3.5), Radius.circular(borderRadius),),),);
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             rect.deflate(1.5), Radius.circular(borderRadius),),
//         Paint()
//           ..color = borderColor
//           ..strokeWidth = borderWidth
//           ..style = PaintingStyle.stroke,);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
