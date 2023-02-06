//implements WebSocketChannel
import 'dart:async';
import 'dart:io';

class WebSocketChannel {
  final WebSocket _webSocket;
  final StreamController _controller;
  final StreamController _sinkController;
  final Stream _stream;
  final StreamSink _sink;

  WebSocketChannel(this._webSocket)
      : _controller = new StreamController(),
        _sinkController = new StreamController(),
        _stream = new Stream.fromFuture(_webSocket.done).asBroadcastStream(),
        _sink = StreamSink(_webSocket) {
    _webSocket.listen((data) {
      _controller.add(data);
    }, onError: (error) {
      _controller.addError(error);
    }, onDone: () {
      _controller.close();
    });
  }

  Stream get stream => _stream;

  StreamSink get sink => _sink;

  void close() {
    _webSocket.close();
  }
}

//StreamSink can't be instantiated
class StreamSink {
  final WebSocket _webSocket;

  StreamSink(this._webSocket);

  void add(data) {
    _webSocket.add(data);
  }

  void addError(error) {
    _webSocket.addError(error);
  }

  void close() {
    _webSocket.close();
  }
}

class WebSocketClient {
  final String url;
  WebSocketChannel? _channel;

  WebSocketClient(this.url);

  Future<WebSocketChannel> connect() async {
    if (_channel != null) {
      return _channel!;
    }
    var webSocket = await WebSocket.connect(url);
    _channel = WebSocketChannel(webSocket);
    return _channel!;
  }

  void close() {
    _channel?.close();
  }

  send(data) {
    _channel?.sink.add(data);
  }

  onMessage(callback) {
    _channel?.stream.listen(callback);
  }

  onClosed(callback) {
    _channel?.stream.listen((event) {
      callback();
    });
  }

  onError(callback) {
    _channel?.stream.listen((event) {
      callback();
    });
  }

  onOpen(callback) {
    _channel?.stream.listen((event) {
      callback();
    });
  }
}