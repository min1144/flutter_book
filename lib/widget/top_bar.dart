import 'package:flutter/material.dart';
import 'package:flutter_book/constants/routes.dart';

class TopBar extends StatefulWidget {
  final double opacity;
  bool isShowBack = false;

  TopBar(this.opacity);

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final List _isHovering = [
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size(screenSize.width, 1000),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey.shade200),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                  visible: widget.isShowBack ? true : false,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )),

              //
              const Text(
                APP_NAME,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  letterSpacing: 3,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[0] = true
                              : _isHovering[0] = false;
                        });
                      },
                      onTap: () {
                        Navigator.popUntil(context, ModalRoute.withName(HOME));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _isHovering[0]
                              ? Colors.grey.shade200
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: const Text(
                            'Home',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        height: 40,
                        width: 80,
                      ),
                    ),

                    //histroy
                    SizedBox(width: 10),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[1] = true
                              : _isHovering[1] = false;
                        });
                      },
                      onTap: () {
                        Navigator.pushNamed(context, HISTORY);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _isHovering[1]
                              ? Colors.grey.shade200
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: const Text(
                            'History',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        height: 40,
                        width: 80,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
