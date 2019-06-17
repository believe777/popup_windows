import 'package:flutter/material.dart';
import 'package:popup_windows/popup_windows.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;

class PopupWindowRoute<T> extends PopupRoute<T> {
  PopupWindowRoute(
      {this.child,
      this.position,
      this.direction,
      this.intelligentConversion,
      this.button});

  final Widget child;
  final RelativeRect position;
  final Direction direction;
  final bool intelligentConversion;
  final Size button;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    switch (direction) {
      case Direction.Bottom:
      case Direction.Left:
      case Direction.Right:
      case Direction.Top:
        return child;
      case Direction.Window_Left:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(animation),
          child: child, // child is the value returned by pageBuilder
        );
        break;
      case Direction.Window_Bottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child, // child is the value returned by pageBuilder
        );
        break;
      case Direction.Window_Right:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child, // child is the value returned by pageBuilder
        );
        break;
      case Direction.Window_Top:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: const Offset(0.0, 0.0),
          ).animate(animation),
          child: child, // child is the value returned by pageBuilder
        );
        break;
    }
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: this.animation,
        curve: Interval(0.0, 1.0),
      ),
      child: CustomSingleChildLayout(
        delegate: _PopupMenuRouteLayout(
          position,
          direction: direction,
          intelligentConversion: intelligentConversion,
          button: button,
        ),
        child: child,
      ),
    );
  }

  @override
  String get barrierLabel => null;
}

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.position, {
    this.direction,
    this.intelligentConversion,
    this.button,
  });

  final RelativeRect position;
  final Direction direction;
  final bool intelligentConversion;
  final Size button;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest);
  }

  //childSize代表popupwindow
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    Offset offset = Offset(0.0, 0.0);
    switch (direction) {
      case Direction.Bottom:
        offset = bottom(size, childSize);
        break;
      case Direction.Left:
        offset = left(size, childSize);
        break;
      case Direction.Right:
        offset = right(size, childSize);
        break;
      case Direction.Top:
        offset = top(size, childSize);
        break;
      case Direction.Window_Left:
        offset = windowLeft(size, childSize);
        break;
      case Direction.Window_Bottom:
        offset = windowButton(size, childSize);
        break;
      case Direction.Window_Right:
        offset = windowRight(size, childSize);
        break;
      case Direction.Window_Top:
        offset = windowTop(size, childSize);
        break;
    }
    return offset;
  }

  //触发控件下方
  Offset bottom(Size size, Size childSize) {
    double y = position.top;
    double x;
    //点击view的宽度
    double diffX = button.width - childSize.width;
    x = position.left + diffX / 2;
    if (intelligentConversion) {
      if (x < 0.0) {
        x = 0.0;
      } else if (x > size.width - childSize.width) {
        x = size.width - childSize.width;
      }
      if (y + childSize.height > size.height) {
        double newY = position.top - childSize.height - button.height;
        if (newY > 0) {
          y = newY;
        }
      }
    }
    return Offset(x, y);
  }

  //触发控件上方
  Offset top(Size size, Size childSize) {
    double y = position.top - button.height - childSize.height;
    double diffX = button.width - childSize.width;
    double x = position.left + diffX / 2;
    if (intelligentConversion) {
      if (x < 0.0) {
        x = 0.0;
      } else if (x > size.width - childSize.width) {
        x = size.width - childSize.width;
      }
      if (y < 0.0) {
        y = position.top;
      }
    }
    return Offset(x, y);
  }

  //触发控件左边
  Offset left(Size size, Size childSize) {
    double x = position.left - childSize.width;
    double diffY = button.height - childSize.height;
    double y = position.top + diffY / 2;
    if (intelligentConversion) {
      if (x < 0) {
        x = position.left + button.width;
      }
      if (y < 0.0) {
        y = 0.0;
      } else if (y > size.height - childSize.height) {
        y = size.height - childSize.height;
      }
    }
    return Offset(x, y);
  }

  //触发控件右边
  Offset right(Size size, Size childSize) {
    double x = size.width - position.right;
    double diffY = button.height - childSize.height;
    double y = position.top + diffY / 2;
    if (intelligentConversion) {
      if (x + childSize.width > size.width) {
        double newX = position.left - childSize.width;
        if (newX > 0) {
          x = newX;
        }
      }
      if (y < 0.0) {
        y = 0.0;
      } else if (y > size.height - childSize.height) {
        y = size.height - childSize.height;
      }
    }
    return Offset(x, y);
  }

  //屏幕底部
  Offset windowButton(Size size, Size childSize) {
    double x = (size.width - childSize.width) / 2;
    double y = size.height - childSize.height;
    return Offset(x, y);
  }

  //屏幕左边
  Offset windowLeft(Size size, Size childSize) {
    double x = 0;
    double y = (size.height - childSize.height) / 2;
    return Offset(x, y);
  }

  //屏幕右边
  Offset windowRight(Size size, Size childSize) {
    double x = size.width - childSize.width;
    double y = (size.height - childSize.height) / 2;
    return Offset(x, y);
  }

  //屏幕顶部
  Offset windowTop(Size size, Size childSize) {
    double x = (size.width - childSize.width) / 2;
    double y = 0;
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}
