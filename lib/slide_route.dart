import 'package:flutter/material.dart';

class SlideRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;

  SlideRoute({required this.enterPage, required this.exitPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return Stack(
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0),
                    end: const Offset(-1.0, 0),
                  ).animate(animation),
                  child: exitPage,
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0),
                    end: const Offset(0, 0),
                  ).animate(animation),
                  child: enterPage,
                ),
              ],
            );
          },
        );
}
