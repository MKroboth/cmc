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

import 'package:cmc/cmc/open_url.dart'
    if (dart.library.web) 'package:cmc/cmc/open_url_web.dart';
import 'package:cmc/widgets/login_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: LoginWidget(),
        persistentFooterButtons: [
          ElevatedButton(
            onPressed: () async {
              const url = "https://github.com/MKroboth/cmc";
              openURL(url);
            },
            child: Text("Get the source!"),
          ),
        ],
      );
}
