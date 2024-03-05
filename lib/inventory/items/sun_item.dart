import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/items/emoji_item.dart';

class SunItem extends EmojiItem {
  SunItem()
      : super(
          emoji: "🌞",
          color: const Color.fromARGB(255, 193, 184, 19),
          size: const Size(2, 2),
        );
}
