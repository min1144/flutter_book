import 'dart:math';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  var num = 0;
  BottomBar({
    Key? key,
  }) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

final List<String> words = [
  '네 운명을 사랑하라.\n이것이 지금부터 나의 사랑이 될 것이다!',
  '언제나 현재에 집중할 수 있다면 행복할것이다.',
  '절대 어제를 후회하지 마라.\n인생은 오늘의 나 안에 있고 내일은 스스로 만드는 것이다',
  '평생 살 것처럼 꿈을 꾸어라.\n그리고 내일 죽을 것처럼 오늘을 살아라.'
      '눈물과 더불어 빵을 먹어 보지 않은 자는\n인생의 참다운 맛을 모른다.',
  '용기있는 자로 살아라.\n운이 따라주지 않는다면 용기 있는 가슴으로 불행에 맞서라',
  '되찾을 수 없는게 세월이니 시시한 일에 시간을 낭비하지 말고\n순간순간을 후회 없이 잘 살아야 한다.',
  '삶을 사는 데는 단 두가지 방법이 있다.\n하나는 기적이 전혀 없다고 여기는 것이고 또 다른 하나는 모든 것이 기적이라고 여기는방식이다.'
];

final List<String> authors = [
  '니체',
  '파울로 코엘료',
  'L.론허바드',
  '제임스 딘',
  '괴테',
  '키케로',
  '루소',
  '아인슈타인',
];

class _BottomBarState extends State<BottomBar> {
  var num = 0;

  @override
  void initState() {
    super.initState();
    var random = Random();
    num = random.nextInt(7);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      height: 150,
      width: double.infinity,
      color: Colors.blueGrey[900],
      child: Center(
        child: Text(
          "${words[num]}     - ${authors[num]}",
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
