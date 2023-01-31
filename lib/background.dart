import 'package:flutter/material.dart';

import 'draggable_container.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            // border: Border.all(color:Colors.red),
            color: Colors.grey),
        child:
        const Center(
          child: DraggableContainer(),
        )
        ,
    );
  }
}
