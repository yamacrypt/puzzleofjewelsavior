import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class GalleryBloc {
  final _actionController =  ReplaySubject<Widget>();
  Sink<void> get draw => _countController.sink;

  final _countController = ReplaySubject<Widget>();
  Stream<Widget> get load => _countController.stream;

  //int _count = 0;

  CounterBloc() {
    _actionController.stream.listen((_) {
        _countController.sink.add(_);
      //_countController.sink.add();
    });
  }

  void dispose() {
    _actionController.close();
    _countController.close();
  }
}