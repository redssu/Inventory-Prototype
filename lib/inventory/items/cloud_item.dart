import 'package:flutter/material.dart';
import 'package:inventory_prototype/inventory/items/emoji_item.dart';

class CloudItem extends EmojiItem {
  CloudItem({required String emoji})
      : super(
          emoji: emoji,
          color: const Color.fromARGB(255, 177, 177, 177),
          size: const Size(1, 1),
        );
}
