import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:hafiza_oyunu/image_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int score = 0;
  String selected1 = "";
  String selected2 = "";
  GlobalKey<FlipCardState>? key1;
  GlobalKey<FlipCardState>? key2;
  int firstIndex = -1;
  int secondIndex = -1;
  List<bool> isFlipped = List.generate(12, (_) => false);
  List<int> matchedIndexes = [];
  List<bool> isMatched = List.generate(12, (_) => false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade500,
          title: const Text('KART OYUNU'),
        ),
        body: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 6 / 7,
          ),
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            FlipCardController controller = FlipCardController();
            GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

            String tempImg = imageList[index];
            return myCardWidget(controller, cardKey, tempImg, index.toInt());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('Tekrar butonuna basıldı.');
            setState(() {
              imageList.shuffle();
              isFlipped = List.generate(12, (_) => false);
              score = 0;
            });
          },
          backgroundColor: Colors.blueGrey,
          child: Icon(
            Icons.refresh_rounded,
            color: Colors.brown.shade900,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: builbottom(),
      ),
    );
  }

  Widget myCardWidget(FlipCardController controller,
      GlobalKey<FlipCardState> cardKey, String img, int index) {
    if (!isFlipped[index]) {
      return AspectRatio(
        aspectRatio: 6 / 7,
        child: FlipCard(
          key: cardKey,
          onFlipDone: (value) {
            if (selected1 == '') {
              firstIndex = index;
              selected1 = img;
              key1 = cardKey;
            } else if (selected1 != '' && selected2 == '') {
              secondIndex = index;
              selected2 = img;
              key2 = cardKey;
              if (selected1 == selected2 && key1 != key2) {
                debugPrint('Eşleşti');
                _incrementScore();
                setState(() {
                  isFlipped[firstIndex] = true;
                  isFlipped[secondIndex] = true;
                  addToMatchedIndexes(firstIndex);
                  addToMatchedIndexes(secondIndex);
                  debugPrint('true atandı');
                  selected1 = '';
                  selected2 = '';
                });
              } else if (selected1 != selected2 && key1 != key2) {
                Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    key1?.currentState?.toggleCard();
                    key2?.currentState?.toggleCard();
                    selected1 = '';
                    selected2 = '';
                    debugPrint('False atandı.');
                  });
                });
                debugPrint('Eşleşmedi');
                firstIndex = -1;
                secondIndex = -1;
              }
            }
          },
          onFlip: () {},
          front: Card(
            child: AspectRatio(
              aspectRatio: 6 / 7,
              child: Image.asset(
                'assets/images/soru.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          back: Card(
            child: AspectRatio(
              aspectRatio: 6 / 7,
              child: Image.asset(
                img,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget builbottom() {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          'Score:$score',
          style: TextStyle(fontSize: 20, color: Colors.brown.shade900),
        ),
      ),
    );
  }

  void addToMatchedIndexes(int index) {
    debugPrint('fonksiyona geldi.');
    matchedIndexes.add(index);
    isMatched[index] = true;
  }

  void _incrementScore() {
    debugPrint("score arttı");
    setState(() {
      score++;
    });
  }
}
