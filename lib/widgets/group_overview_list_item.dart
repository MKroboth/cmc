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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:matrix/matrix.dart';

class RoomOverviewListItem extends StatelessWidget {
  Client _client;
  Room _room;

  RoomOverviewListItem(this._client, this._room);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Row(
          children: [
            _buildCircleAvatar(context, _room),
            Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_room.displayname),
                Text(
                  _room.topic,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleAvatar(BuildContext context, Room room) {
    late final Future<dynamic> avatar;

    if (room.avatar != null) {
      avatar = _client.getContent(
          room.avatar!.authority, room.avatar!.path.substring(1),
          allowRemote: true);
    } else {
      avatar = SynchronousFuture(null);
    }

    return FutureBuilder<dynamic?>(
      future: avatar,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return CircleAvatar(
              backgroundImage: Image.memory(snapshot.data.data).image);
        } else {
          return CircleAvatar(child: Text((room.displayname).characters.first));
        }
      },
    );
  }
}
