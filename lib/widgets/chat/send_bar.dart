/*
 * Copyright (c) 2022 by Maximilian Kroboth.
 *
 * This file is part of Cactis CMC.
 *
 * Cactis CMC is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License as published
 *  by the Free Software Foundation,  version 3 of the License.
 *
 * Cactis CMC is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY;  without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 *  with Cactis CMC. If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:cmc/logic/chat_controller.dart';
import 'package:flutter/material.dart';

class SendBar extends StatefulWidget {
  final ChatController controller;

  SendBar({required this.controller});

  @override
  State<StatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends State<SendBar>
    with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  String _currentString = "";

  void _commitText(String string) {
    widget.controller.commitText(string);
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (str) {
                _currentString = str;
              },
              onSubmitted: (str) {
                _commitText(str);
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _commitText(_currentString);
                    },
                  )),
            ),
          ),
        ],
      );
}

class _ChatViewFlowDelegate extends FlowDelegate {
  _ChatViewFlowDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(_ChatViewFlowDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          dx * menuAnimation.value,
          0,
          0,
        ),
      );
    }
  }
}
