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
import 'package:cmc/widgets/chat/chat_event.dart';
import 'package:matrix/matrix.dart' as matrix;

class DirectChatController extends ChatController {
  final String chatId;
  final matrix.Client client;
  final matrix.Room room;

  DirectChatController({required this.chatId, required this.client})
      : room = matrix.Room(
            client: client, id: client.getDirectChatFromUserId(chatId)!);

  @override
  String get name => room.name;

  @override
  void commitText(String string) {
    // TODO: implement commitText
  }

  @override
  void register(void Function(ChatEvent element) addChatItemCallback) {
    room.onUpdate.stream.listen((event) {
      addChatItemCallback(ChatEvent.nullEvent());
    });
    client.sync();
    room.prev_batch = client.prevBatch;
    room.requestHistory(
      onHistoryReceived: () {},
    );
    client.onEvent.stream.listen((matrix.EventUpdate event) async {
      if (event.roomID != room.id) {
        // Not for us.
        return;
      }

      final content = await event.decrypt(room);
      final ev = matrix.Event.fromJson(content.content, room);

      switch (event.type) {
        case matrix.EventUpdateType.timeline:
          final timelineUpdate =
              matrix.TimelineUpdate.fromJson(content.content);

          for (matrix.MatrixEvent a in timelineUpdate.events!) {
            addChatItemCallback(ChatEvent.plainMessage(
                ev.sender.id == client.userID!, content.content.toString()));
          }

          break;
        case matrix.EventUpdateType.state:
          // TODO: Handle this case.
          break;
        case matrix.EventUpdateType.history:
          addChatItemCallback(ChatEvent.plainMessage(
              ev.sender.id == client.userID!, ev.plaintextBody));

          // TODO: Handle this case.
          break;
        case matrix.EventUpdateType.accountData:
          // TODO: Handle this case.
          break;
        case matrix.EventUpdateType.ephemeral:
          // TODO: Handle this case.
          break;
        case matrix.EventUpdateType.inviteState:
          // TODO: Handle this case.
          break;
      }
    });
  }
}
