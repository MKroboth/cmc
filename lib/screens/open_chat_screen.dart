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
import 'package:cmc/logic/direct_chat_controller.dart';
import 'package:cmc/utils/localization.dart';
import 'package:cmc/widgets/chat/chat_view.dart';
import 'package:cmc/widgets/chat/send_bar.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart' as matrix;

class OpenChatScreen extends StatefulWidget {
  final String chatID;
  final matrix.Client client;
  final bool embed;

  OpenChatScreen(this.chatID, {required this.client, this.embed = false});

  @override
  State<StatefulWidget> createState() => _OpenChatScreenState();
}

class _OpenChatScreenState extends State<OpenChatScreen> {
  late ChatController _chatController;

  @override
  void initState() {
    _chatController =
        DirectChatController(chatId: widget.chatID, client: widget.client);
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
          Expanded(child: ChatView(controller: _chatController)),
          SendBar(controller: _chatController)
        ],
      );
}
