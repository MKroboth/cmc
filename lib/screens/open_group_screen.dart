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
import 'package:cmc/logic/chat_room_controller.dart';
import 'package:cmc/utils/localization.dart';
import 'package:cmc/widgets/chat/chat_view.dart';
import 'package:cmc/widgets/chat/send_bar.dart';
import 'package:flutter/material.dart';

class OpenRoomScreen extends StatefulWidget {
  final String roomId;
  final bool embed;

  OpenRoomScreen(this.roomId, {this.embed = false});

  @override
  State<StatefulWidget> createState() => _OpenChatRoomState();
}

class _OpenChatRoomState extends State<OpenRoomScreen> {
  late ChatController _chatController;

  @override
  void initState() {
    _chatController = ChatRoomController(roomId: widget.roomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.embed
      ? _buildBody(context)
      : Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.applicationTitle),
          ),
          body: _buildBody(context));

  Widget _buildBody(BuildContext context) => Column(
        children: [
          ChatView(controller: _chatController),
          SendBar(controller: _chatController)
        ],
      );
}
