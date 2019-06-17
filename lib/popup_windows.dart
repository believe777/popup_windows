library popup_windows;

import 'package:flutter/material.dart';
import 'package:popup_windows/popup_window_route.dart';

enum Direction {
  //控件上方
  Top,
  //控件下方
  Bottom,
  //控件左边
  Left,
  //控件右边
  Right,
  //屏幕上方
  Window_Top,
  //屏幕左边
  Window_Left,
  //屏幕下方
  Window_Bottom,
  //屏幕右边
  Window_Right,
}

class PopupWindowWidget<T> extends StatefulWidget {
  const PopupWindowWidget(
      {Key key,
      @required this.showChild,
      this.intelligentConversion = false,
      @required this.child,
      this.direction = Direction.Bottom,
      this.offset = Offset.zero})
      : super(key: key);

  //超出边界自动换方向；left⇋right、top⇋bottom
  //todo:后续会找出最优方向
  final bool intelligentConversion;

  //触发弹出展示的widget
  final Widget child;

  //弹出展示的widget
  final Widget showChild;

  //展示方向
  final Direction direction;

  //showChild展示位置偏移量,默认居中展示(设置margin时可能不居中，可以设置此变量居中;left=n,right=-n)
  final Offset offset;

  @override
  _PopupWindowWidgetState createState() => _PopupWindowWidgetState();
}

class _PopupWindowWidgetState<T> extends State<PopupWindowWidget<T>> {
  Offset getOffset(RenderBox button) {
    switch (widget.direction) {
      case Direction.Left:
      case Direction.Right:
        return Offset(widget.offset.dx, widget.offset.dy);
      case Direction.Top:
      case Direction.Bottom:
        return Offset(widget.offset.dx, button.size.height + widget.offset.dy);
      case Direction.Window_Bottom:
      case Direction.Window_Left:
      case Direction.Window_Right:
      case Direction.Window_Top:
      default:
        return Offset(0.0, 0.0);
    }
  }

  void showPopupWindow() {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(getOffset(button), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    Navigator.push<T>(
        context,
        PopupWindowRoute<T>(
          child: widget.showChild,
          button: button.size,
          position: position,
          direction: widget.direction,
          intelligentConversion: widget.intelligentConversion,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showPopupWindow,
      child: widget.child,
    );
  }
}
