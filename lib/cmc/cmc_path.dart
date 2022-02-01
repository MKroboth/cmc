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

enum CMCPathType {
  Unknown,
  Home,
  Login,
  Settings,
  ChatOverview,
  GroupOverview,
  OpenChat,
  OpenGroup,
}

class CMCPath {
  final String? id;
  final CMCPathType pathType;
  final bool isValid;

  const CMCPath.home()
      : id = null,
        pathType = CMCPathType.Home,
        isValid = true;

  const CMCPath.login()
      : id = null,
        pathType = CMCPathType.Login,
        isValid = true;

  const CMCPath.unknown()
      : id = null,
        pathType = CMCPathType.Unknown,
        isValid = true;

  const CMCPath.chatOverview()
      : id = null,
        pathType = CMCPathType.ChatOverview,
        isValid = true;

  const CMCPath.groupOverview()
      : id = null,
        pathType = CMCPathType.GroupOverview,
        isValid = true;

  const CMCPath.openChat(String this.id)
      : pathType = CMCPathType.OpenChat,
        isValid = true;

  const CMCPath.openGroup(String this.id)
      : pathType = CMCPathType.OpenGroup,
        isValid = true;

  const CMCPath.settings(String this.id)
      : pathType = CMCPathType.Settings,
        isValid = true;

  const CMCPath.invalidID(this.pathType, this.id) : isValid = false;

  bool get isHome => isValid && pathType == CMCPathType.Home;

  bool get isLogin => isValid && pathType == CMCPathType.Login;

  bool get isUnknown => isValid && pathType == CMCPathType.Unknown;

  bool get isChatOverview => isValid && pathType == CMCPathType.ChatOverview;

  bool get isGroupOverview => isValid && pathType == CMCPathType.GroupOverview;

  bool get isOpenChat => isValid && pathType == CMCPathType.OpenChat;

  bool get isOpenGroup => isValid && pathType == CMCPathType.OpenGroup;

  bool get isSettings => isValid && pathType == CMCPathType.Settings;

  bool get isInvalid => !isValid;
}
