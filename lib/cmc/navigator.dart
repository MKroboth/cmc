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

library route_navigator;

import 'package:cmc/cmc/cmc_path.dart';
import 'package:cmc/cmc/router_delegate.dart';
import 'package:flutter/material.dart';

class RouteNavigator {
  late final CMCRouterDelegate _delegate;

  RouteNavigator.of(BuildContext context)
      : this._delegate = Router.of(context).routerDelegate as CMCRouterDelegate;

  Future<void> navigateTo(CMCPath path) async {
    await _delegate.setNewRoutePath(path);
  }
}
