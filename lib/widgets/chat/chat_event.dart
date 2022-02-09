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

enum ChatEventType {
  Null,
  PlainMessage,
}

class NullChatEvent extends ChatEvent {
  const NullChatEvent() : super(ChatEventType.Null);
}

class PlainMessage extends ChatEvent {
  final bool fromSelf;
  final String content;

  const PlainMessage(this.fromSelf, this.content)
      : super(ChatEventType.PlainMessage);
}

abstract class ChatEvent {
  final ChatEventType type;

  const ChatEvent(this.type);

  static NullChatEvent nullEvent() => NullChatEvent();

  static PlainMessage plainMessage(bool fromSelf, String content) =>
      PlainMessage(fromSelf, content);
}
