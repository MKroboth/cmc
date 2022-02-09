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
import 'package:cmc/widgets/chat/chat_element.dart';
import 'package:flutter/cupertino.dart';

import 'chat_event.dart';

class ChatView extends StatefulWidget {
  final ChatController controller;

  ChatView({required this.controller});

  @override
  State<StatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    widget.controller.register(_addChatItemCallback);
    super.initState();
  }

  final _chatElements = <Widget>[];

  void _addChatItemCallback(ChatEvent element) {
    switch (element.type) {
      case ChatEventType.Null:
        // TODO: Handle this case.
        break;
      case ChatEventType.PlainMessage:
        setState(() {
          _chatElements
              .add(ChatElement(child: Text((element as PlainMessage).content)));
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: _chatElements,
      );
}
