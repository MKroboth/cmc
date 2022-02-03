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
import 'package:flutter/rendering.dart';
import 'package:matrix/matrix.dart';

class ChatOverviewListItem extends StatelessWidget {
  Client _client;
  String userId;
  String roomId;

  ChatOverviewListItem(this._client, this.userId, this.roomId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return _buildItem(context, snapshot.data!);
        } else {
          return Text(userId);
        }
      },
      future: _client.getProfileFromUserId(userId),
    );
  }

  Widget _buildItem(BuildContext context, Profile profile) {
    return Card(
      margin: EdgeInsets.all(4),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Row(
          children: [
            _buildCircleAvatar(context, profile),
            Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.displayName ??
                      profile.userId.localpart ??
                      profile.userId,
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 230),
                    child: Text(
                      profile.userId,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleAvatar(BuildContext context, Profile profile) {
    late final Future<dynamic> avatar;

    if (profile.avatarUrl != null) {
      avatar = _client.getContent(
          profile.avatarUrl!.authority, profile.avatarUrl!.path.substring(1),
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
          return CircleAvatar(
              child: Text(
                  (profile.displayName ?? profile.userId.replaceAll("@", ""))
                      .characters
                      .first));
        }
      },
    );
  }
}
