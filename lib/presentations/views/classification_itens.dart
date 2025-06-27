import 'dart:math';
import 'package:flutter/material.dart';

import '../../widgets/status_card.dart';

enum Typeitens { decoration, utils, fun }

class StatusScaffold extends StatelessWidget {
  const StatusScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Tracking")),
      body: ListView(
        padding: EdgeInsets.only(right: 16, bottom: 16, top: 48, left: 16),
        children: [
          StatusCard(
            id: Random().toString(),
            status: Typeitens.decoration,
            title: "Decoration",
            subtitle: "decorating spaces",
            isActive: true,
          ),
          StatusCard(
            id: Random().toString(),
            status: Typeitens.utils,
            title: "Utils",
            subtitle: "Everyday utilities",
            isActive: false,
          ),
          StatusCard(
            id: Random().toString(),
            status: Typeitens.fun,
            title: "Fun",
            subtitle: "Fun Objects",
            isActive: false,
          ),
          // Você pode adicionar mais cards aqui se necessário
        ],
      ),
    );
  }
}
