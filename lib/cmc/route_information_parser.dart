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

import 'package:cmc/cmc/cmc_path.dart';
import 'package:flutter/cupertino.dart';

class CMCRouteInformationParser extends RouteInformationParser<CMCPath> {
  @override
  Future<CMCPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location != null) {
      final uri = Uri.parse(routeInformation.location!);

      if (uri.pathSegments.length == 0) return CMCPath.home();

      if (uri.pathSegments.length == 1) {
        switch (uri.pathSegments[0]) {
          case 'chat':
            return CMCPath.chatOverview();
          case 'groups':
            return CMCPath.groupOverview();
          case 'settings':
            return CMCPath.settings("/");
        }
      }

      if (uri.pathSegments.length >= 2) {
        String rest = uri.pathSegments.sublist(1).join("/");
        switch (uri.pathSegments[0]) {
          case 'chat':
            if (isValidChatID(rest))
              return CMCPath.openChat(rest);
            else
              return CMCPath.invalidID(CMCPathType.OpenChat, rest);
          case 'groups':
            if (isValidGroupsID(rest))
              return CMCPath.openGroup(rest);
            else
              return CMCPath.invalidID(CMCPathType.OpenGroup, rest);
          case 'settings':
            if (isValidSettingsID(rest))
              return CMCPath.openGroup(rest);
            else
              return CMCPath.invalidID(CMCPathType.Settings, rest);
        }
      }
    }

    return CMCPath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(CMCPath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isHome) {
      return RouteInformation(location: '/');
    }
    if (path.isGroupOverview) {
      return RouteInformation(location: '/groups');
    }
    if (path.isChatOverview) {
      return RouteInformation(location: "/chat");
    }
    if (path.isLogin) {
      return RouteInformation(location: "/login");
    }
    if (path.isOpenGroup) {
      return RouteInformation(location: "/groups/${path.id}");
    }
    if (path.isOpenChat) {
      return RouteInformation(location: "/chat/${path.id}");
    }
    if (path.isSettings) {
      return RouteInformation(location: "/settings/${path.id}");
    }
    if (path.isInvalid) {
      return RouteInformation(location: "/invalid/${path.id}");
    }

    return null;
  }

  bool isValidChatID(String rest) {
    // TODO validate chat id.
    return true;
  }

  bool isValidGroupsID(String rest) {
    // TODO validate group id.
    return true;
  }

  bool isValidSettingsID(String _) => true;
}
