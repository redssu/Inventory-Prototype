import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/inventory_manager.dart';

class InventoryWrapper extends StatelessWidget {
  final InventoryManager manager;
  final List<Widget> children;

  const InventoryWrapper({
    required this.manager,
    this.children = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Listener(
        onPointerDown: manager.onPointerDown,
        child: MouseRegion(
          onHover: manager.onHover,
          child: ListenableBuilder(
            listenable: manager,
            builder: (context, snapshot) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  ...manager.build(context),
                  ...children,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
