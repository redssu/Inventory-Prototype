import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/items/emoji_item.dart';

class CarItem extends EmojiItem {
  CarItem()
      : super(
          emoji: "🏎️",
          color: const Color.fromARGB(255, 242, 52, 52),
          size: const Size(2, 1),
        );
}
