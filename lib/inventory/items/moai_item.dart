import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/items/emoji_item.dart';

class MoaiItem extends EmojiItem {
  MoaiItem()
      : super(
          emoji: "🗿",
          color: const Color.fromRGBO(77, 78, 76, 1),
          size: const Size(1, 2),
        );
}
