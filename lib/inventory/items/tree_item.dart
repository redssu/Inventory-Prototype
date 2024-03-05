import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/items/emoji_item.dart';

class TreeItem extends EmojiItem {
  TreeItem()
      : super(
          emoji: "🌳",
          color: const Color.fromARGB(255, 104, 159, 48),
          size: const Size(2, 3),
        );
}
