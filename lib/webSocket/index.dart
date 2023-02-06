//create a simple web socket client class initialized with a url

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  //region 会变的变量
  late WebSocketChannel _channel;
  //endregion

  //region 不会变的变量
  late String _url;
  //endregion

  //region  初始化状态
  WebSocketClient(String url) {
    _url = url;
    _channel = IOWebSocketChannel.connect(_url);
  }
  //endregion

  //region 事件
  //region 发送消息
  void sendMessage(String message) {
    _channel.sink.add(message);
  }
  //endregion

  //region 接收消息
  // Stream<String> get onMessage => _channel.stream;
  // //how to fix this error: The argument type 'Stream<dynamic>' can't be assigned to the parameter type 'Stream<String>'
  //
  //endregion

  //region 关闭连接
  void close() {
    _channel.sink.close();
  }
  //endregion
  //endregion
}