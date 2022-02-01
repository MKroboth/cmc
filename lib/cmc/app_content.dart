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
import 'package:cmc/cmc/route_information_parser.dart';
import 'package:cmc/cmc/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_path.dart';

class CMCAppContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CMCAppContentState();
}

class _CMCAppContentState extends State<CMCAppContent> {
  CMCRouterDelegate _routerDelegate = CMCRouterDelegate();
  CMCRouteInformationParser _routeInformationParser =
      CMCRouteInformationParser();
  PlatformRouteInformationProvider _platformRouteInformationProvider =
      PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(location: '/'));

  // This widget contains the real content of the app.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppPath>(
        create: (context) => AppPath(CMCPath.home()),
        child: MaterialApp.router(
          title: 'Cactis Matrix Client',
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeInformationParser,
          routeInformationProvider: _platformRouteInformationProvider,
        ));
  }
}
