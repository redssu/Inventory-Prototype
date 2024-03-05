import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/items/emoji_item.dart';

class DuckItem extends EmojiItem {
  DuckItem()
      : super(
          emoji: "🦆",
          color: const Color.fromARGB(255, 215, 244, 186),
          size: const Size(1, 1),
        );
}
