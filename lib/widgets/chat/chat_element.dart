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

import 'package:flutter/material.dart';

enum ChatElementDirection {
  Received,
  Sent,
}

extension WhenChatElementDirection on ChatElementDirection {
  T? whenReceived<T>(T Function() received) =>
      (this == ChatElementDirection.Received) ? received() : null;

  T? whenSent<T>(T Function() sent) =>
      (this == ChatElementDirection.Sent) ? sent() : null;

  T whenLazy<T>({required T Function() received, required T Function() sent}) =>
      (this == ChatElementDirection.Received) ? received() : sent();

  T when<T>({required T received, required T sent}) =>
      (this == ChatElementDirection.Received) ? received : sent;
}

class ChatElement extends StatelessWidget {
  final Widget child;
  final Widget? avatar;

  final ChatElementDirection direction;

  ChatElement(
      {required this.child,
      this.direction = ChatElementDirection.Sent,
      this.avatar});

  ChatElement.sent({required Widget child, Widget? avatar})
      : this(
            child: child, avatar: avatar, direction: ChatElementDirection.Sent);

  ChatElement.received({required Widget child, Widget? avatar})
      : this(
            child: child,
            avatar: avatar,
            direction: ChatElementDirection.Received);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(left: 10, right: 14, top: 10, bottom: 10),
        child: Align(
          alignment: direction.when(
              received: Alignment.topLeft, sent: Alignment.topRight),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: direction.when(
                  received: Colors.grey.shade200,
                  sent: Colors.green.shade200,
                )),
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ),
      );
}
