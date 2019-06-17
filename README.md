# popup_windows

参考android的样式开发的flutter版PopupWindos.

# 添加依赖

打开pubspec.yaml文件并添加以下依赖
popup_windows:^0.0.1

# 使用栗子

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PopupWindos Demo',
      home: MyHomePage(title: 'PopupWindows'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: Container(
        alignment: Alignment.topLeft,
        child: PopupWindowWidget(
          //offset: Offset(40.0, 0.0),
          intelligentConversion: true,
          direction: Direction.Window_Bottom,
          child: Container(
            color: Colors.pinkAccent,
            padding: EdgeInsets.all(20.0),
            //margin: EdgeInsets.only(left: 40.0),
            child: Text(
              'left',
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
          showChild: Container(
            height: 200.0,
            alignment: Alignment.bottomCenter,
            color: Color(0X33000000),
            child: Container(
              height: 100.0,
              color: Colors.blueAccent,
            ),
          ),
        ),
      )),
    );
  }

## 具体参数含义已在代码中备注
