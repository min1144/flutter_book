import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final double topMargin;

  const EmptyView({Key? key, required this.topMargin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: topMargin,
        ),
        alignment: Alignment.center,
        child: const Text(
          '데이터가 없어요 😟',
          style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Colors.black54),
          maxLines: 1,
        ));
  }
}
