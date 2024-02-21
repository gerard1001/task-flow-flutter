import 'package:flutter/material.dart';

class PageWrapper extends StatefulWidget {
  final Widget child;

  const PageWrapper({super.key, required this.child});

  @override
  State<PageWrapper> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Flexible(
                  child: Column(children: [Expanded(child: widget.child)])),
            ),
          ],
        ),
      ),
    );
  }
}
