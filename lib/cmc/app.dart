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

import 'package:cmc/cmc/app_content.dart';
import 'package:cmc/providers/login_provider.dart' as login_provider;
import 'package:cmc/providers/theme_provider.dart' as theme_provider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CMCApp extends StatelessWidget {
  // This widget is the root of your application.
  // Use it to configure providers
  // for CMCAppContent.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        theme_provider.provider,
        login_provider.provider,
      ],
      child: CMCAppContent(),
    );
  }
}
