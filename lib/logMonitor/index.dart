import 'dart:io';

class LogMonitor{
  static WebSocket? _webSocket;

  static final LogMonitor _singleton = LogMonitor._internal();
  factory LogMonitor() {
    var ws =WebSocket.connect('ws://127.0.0.1:8080');
    ws.then((webSocket) {
      print('连接成功');
      _webSocket = webSocket;
      _webSocket!.listen(
        (message) {
          print('收到消息: $message');
        },
        onDone: () {
          print('连接关闭');
        },
        onError: (error) {
          print('连接出错: $error');
        },
      );
    });
    return _singleton;
  }
  LogMonitor._internal();

  void log(String msg){
      print(msg + '  ${DateTime.now()}');
      _webSocket?.add(msg + '  ${DateTime.now()}');
    }
}

var console =LogMonitor();

//region 测试代码
// testFunction(){
//   var start = DateTime.now();
//   print('延迟执行 开始时间 ${DateTime.now()}');
//   for(var i=0;i<100000;i++)
//   {
//     console.log('定时器 ${DateTime.now()}');
//   }
//   var end = DateTime.now();
//   var duration = end.difference(start);
//   print('总计耗时 ${duration.inMilliseconds}');
// }
// for(var i=0;i<1;i++)
// {
//   Future.delayed(
//       Duration(milliseconds: 1000),
//       testFunction
//   );
// }

// Timer.periodic(Duration(milliseconds: 1), (timer) {
//   console.log('定时器 ${timer.tick}');
// });
//endregion