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

import 'package:cmc/data/login_info.dart';
import 'package:cmc/widgets/chat_overview_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final bool embed;

  const ChatScreen({this.embed = false});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) =>
      widget.embed ? _buildBody(context) : throw "Not supported!";

  Widget _buildBody(BuildContext context) {
    final loginInfo = Provider.of<CMCLoginInfo>(context);
    final client = loginInfo.loginStatus?.client;
    final entries = client!.directChats.entries.toList(growable: false);

    return ListView.builder(
      itemBuilder: (context, index) {
        return ChatOverviewListItem(
            client, entries[index].key, entries[index].value.first);
      },
      itemCount: entries.length,
    );
  }
}
