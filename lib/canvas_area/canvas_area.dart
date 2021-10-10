import 'dart:math';

import 'package:flutter/material.dart';

import 'models/fruit.dart';
import 'models/fruit_part.dart';
import 'models/touch_slice.dart';
import 'slice_painter.dart';

class CanvasArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CanvasAreaState();
  }
}

class _CanvasAreaState<CanvasArea> extends State {
  int score = 0;
  int heart = 1;
  List<String> item = ['banana', 'melon'];
  List<String> items = ['heart', 'bomb'];
  TouchSlice? touchSlice;
  List<Fruit> fruits = [];
  List<FruitPart> fruitParts = [];
  List<Fruit> fruitEffect = [];
  Container effectBomb = Container();

  void newGame() {
    touchSlice = null;
    score = 0;
    heart = 1;
    fruits = [];
    fruitParts = [];
    fruitEffect = [];
    effectBomb = Container();
  }

  @override
  void initState() {
    _spawnRandomFruit();
    _spawnBomb();
    _tick();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _spawnBomb() {
    setState(
      () {
        fruits.add(
          Fruit(
              position: Offset(0, 200),
              width: 80,
              height: 80,
              additionalForce: Offset(5 + Random().nextDouble() * 5, Random().nextDouble() * -10),
              rotation: Random().nextDouble() / 3 - 0.16,
              name: items[Random().nextInt(2)]),
        );
      },
    );
    Future.delayed(Duration(seconds: 5), _spawnBomb);
  }

  Container _getBackgroundEnd(int score) {
    Future.delayed(Duration(seconds: 1), _getBackground);
    return Container(
      color: Colors.blue[600],
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'คะแนนรวม $score',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
          ),
          SizedBox(height: 50),
          IconButton(
            onPressed: () {
              newGame();
            },
            icon: Icon(
              Icons.refresh,
              size: 50,
              color: Colors.yellow,
            ),
          )
        ],
      ),
    );
  }

  void _spawnRandomFruit() {
    fruits.add(
      Fruit(
          position: Offset(400, 200),
          width: 80,
          height: 80,
          additionalForce: Offset(-5 + Random().nextDouble() * -5, Random().nextDouble() * -5),
          rotation: Random().nextDouble() / 3 - 0.16,
          name: item[Random().nextInt(2)]),
    );
    fruits.add(
      Fruit(
          position: Offset(0, 200),
          width: 80,
          height: 80,
          additionalForce: Offset(5 + Random().nextDouble() * 5, Random().nextDouble() * -10),
          rotation: Random().nextDouble() / 3 - 0.16,
          name: item[Random().nextInt(2)]),
    );
  }

  void _tick() {
    setState(() {
      for (Fruit fruit in fruits) {
        fruit.applyGravity();
      }
      for (FruitPart fruitPart in fruitParts) {
        fruitPart.applyGravity();
      }
      for (Fruit effect in fruitEffect) {
        effect.applyGravity();
      }
      if (Random().nextDouble() > 0.95) {
        _spawnRandomFruit();
      }
    });

    Future.delayed(Duration(milliseconds: 30), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _getStack());
  }

  List<Widget> _getStack() {
    List<Widget> widgetsOnStack = [];
    if (heart != 0) {
      widgetsOnStack.add(_getBackground());
      widgetsOnStack.addAll(_getFruitEffect());
      widgetsOnStack.add(_getSlice());
      widgetsOnStack.addAll(_getFruitParts());
      widgetsOnStack.addAll(_getFruits());
      widgetsOnStack.add(_getGestureDetector());
      widgetsOnStack.add(effectBomb);
      widgetsOnStack.add(Positioned(
        left: 16,
        top: 16,
        child: Image.asset(
          'assets/images/heart_uncut.png',
          height: 30,
          fit: BoxFit.fitHeight,
        ),
      ));
      widgetsOnStack.add(Positioned(
          left: 50,
          top: 20,
          child: Text(
            '$heart',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          )));
      widgetsOnStack.add(Positioned(
          right: 16,
          top: 16,
          child: Text(
            'Score: $score',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )));
    } else {
      widgetsOnStack.add(_getBackgroundEnd(score));
    }

    return widgetsOnStack;
  }

  Container _getBackground() {
    return Container(
      decoration: new BoxDecoration(
          gradient: new RadialGradient(
        stops: [0.2, 1.0],
        colors: [Color(0xffFFB75E), Color(0xffED8F03)],
      )),
    );
  }

  Widget _getSlice() {
    if (touchSlice == null) {
      return Container();
    }

    return CustomPaint(
      size: Size.infinite,
      painter: SlicePainter(
        pointsList: touchSlice!.pointsList,
      ),
    );
  }

  List<Widget> _getFruits() {
    List<Widget> list = [];

    for (Fruit fruit in fruits) {
      if (fruit.name == "banana") {
        addListFruits(list, fruit);
      }
      if (fruit.name == "melon") {
        addListFruits(list, fruit);
      }
      if (fruit.name == "bomb") {
        addListFruits(list, fruit);
      }
      if (fruit.name == "heart") {
        addListFruits(list, fruit);
      }
    }
    return list;
  }

  void addListFruits(List<Widget> list, Fruit fruit) {
    return list.add(
      Positioned(
        top: fruit.position.dy,
        left: fruit.position.dx,
        child: Transform.rotate(
          angle: fruit.rotation * pi * 2,
          child: Image.asset(
            'assets/images/' + fruit.name + '_uncut.png',
            height: 80,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  List<Widget> _getFruitParts() {
    List<Widget> list = [];

    for (FruitPart fruitPart in fruitParts) {
      if (fruitPart.name == "banana") {
        addFruitParts(list, fruitPart);
      }
      if (fruitPart.name == "melon") {
        addFruitParts(list, fruitPart);
      }
    }
    return list;
  }

  void addFruitParts(List<Widget> list, FruitPart fruitPart) {
    return list.add(
      Positioned(
        top: fruitPart.position.dy,
        left: fruitPart.position.dx,
        child: Transform.rotate(
          angle: fruitPart.rotation * pi * 2,
          child: Image.asset(
              fruitPart.isLeft
                  ? 'assets/images/' + fruitPart.name + '_cut.png'
                  : 'assets/images/' + fruitPart.name + '_cut_right.png',
              height: 80,
              fit: BoxFit.fitHeight),
        ),
      ),
    );
  }

  List<Widget> _getFruitEffect() {
    List<Widget> list = [];
    for (Fruit fruit in fruitEffect) {
      if (fruit.name == "banana") {
        addFruitEffect(list, fruit);
      }
      if (fruit.name == "melon") {
        addFruitEffect(list, fruit);
      }
    }
    return list;
  }

  void addFruitEffect(List<Widget> list, Fruit fruit) {
    return list.add(
      Positioned(
        top: fruit.position.dy,
        left: fruit.position.dx,
        child: Image.asset(
          'assets/images/' + fruit.name + '_splash.png',
          height: 80,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _getGestureDetector() {
    return GestureDetector(onScaleStart: (details) {
      setState(() {
        _setNewSlice(details);
      });
    }, onScaleUpdate: (details) {
      setState(() {
        _addPointToSlice(details);
        _checkCollision();
      });
    }, onScaleEnd: (details) {
      setState(() {
        _resetSlice();
      });
    });
  }

  _checkCollision() {
    if (touchSlice == null) {
      return;
    }

    for (Fruit fruit in List.from(fruits)) {
      bool firstPointOutside = false;
      bool secondPointInside = false;

      for (Offset point in touchSlice!.pointsList) {
        if (!firstPointOutside && !fruit.isPointInside(point)) {
          firstPointOutside = true;
          continue;
        }

        if (firstPointOutside && fruit.isPointInside(point)) {
          secondPointInside = true;
          continue;
        }

        if (secondPointInside && !fruit.isPointInside(point)) {
          if (fruit.name == "banana") {
            fruits.remove(fruit);
            _turnFruitIntoParts(fruit);
          }

          if (fruit.name == "bomb") {
            fruits.remove(fruit);
            setState(() {
              heart--;
              effectBomb = Container(
                color: Colors.white,
              );
            });
            Future.delayed(Duration(seconds: 1), () {
              effectBomb = Container();
            });
            // if (heart == 0) {
            //   dispose();
            // }
          }

          if (fruit.name == "melon") {
            fruits.remove(fruit);
            _turnFruitIntoParts(fruit);
          }
          if (fruit.name == "heart") {
            fruits.remove(fruit);
            setState(() {
              effectBomb = Container(
                color: Colors.pink.withOpacity(0.5),
              );
            });
            Future.delayed(Duration(milliseconds: 200), () {
              effectBomb = Container();
            });
            heart++;
          }
          score += 10;
          break;
        }
      }
    }
  }

  void _turnFruitIntoParts(Fruit hit) {
    FruitPart leftFruitPart = FruitPart(
        position: Offset(hit.position.dx - hit.width / 8, hit.position.dy),
        width: hit.width / 2,
        height: hit.height,
        isLeft: true,
        gravitySpeed: hit.gravitySpeed,
        additionalForce: Offset(hit.additionalForce.dx - 1, hit.additionalForce.dy - 5),
        rotation: hit.rotation,
        name: hit.name);

    FruitPart rightFruitPart = FruitPart(
        position: Offset(hit.position.dx + hit.width / 4 + hit.width / 8, hit.position.dy),
        width: hit.width / 2,
        height: hit.height,
        isLeft: false,
        gravitySpeed: hit.gravitySpeed,
        additionalForce: Offset(hit.additionalForce.dx + 1, hit.additionalForce.dy - 5),
        rotation: hit.rotation,
        name: hit.name);
    Fruit f = Fruit(
        position: Offset(hit.position.dx, hit.position.dy),
        width: 80,
        height: 80,
        additionalForce: Offset(5 + Random().nextDouble() * 5, Random().nextDouble() * -10),
        rotation: Random().nextDouble() / 3 - 0.16,
        name: hit.name);

    setState(() {
      fruitParts.add(leftFruitPart);
      fruitParts.add(rightFruitPart);
      fruitEffect.add(f);
      fruits.remove(hit);
    });
  }

  void _resetSlice() {
    touchSlice = null;
  }

  void _setNewSlice(details) {
    touchSlice = TouchSlice(pointsList: [details.localFocalPoint]);
  }

  void _addPointToSlice(ScaleUpdateDetails details) {
    if (touchSlice!.pointsList.length > 16) {
      touchSlice!.pointsList.removeAt(0);
    }
    touchSlice!.pointsList.add(details.localFocalPoint);
  }
}
