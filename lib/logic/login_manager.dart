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

import 'dart:async';

import 'package:cmc/data/login_info.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

import 'login_error.dart';

class LoginManager {
  Future<CMCLoginStatus> login(String username, String password) async {
    Client client = Client(
      "CMC",
      databaseBuilder: (Client c) async {
        await Hive.initFlutter();
        final FamedlySdkHiveDatabase db = FamedlySdkHiveDatabase("cmc");
        await db.open();
        return db;
      },
      verificationMethods: {KeyVerificationMethod.emoji},
      supportedLoginTypes: {AuthenticationTypes.password},
    );

    final homeserverDiscovery =
        await client.getDiscoveryInformationsByUserId(username);
    await client.checkHomeserver(homeserverDiscovery.mHomeserver.baseUrl);

    try {
      final status = await client.login(
        LoginType.mLoginPassword,
        identifier: AuthenticationUserIdentifier(user: username),
        password: password,
      );

      print(
          "Client supports encryption ${client.encryptionEnabled ? "yes" : "no"}");

      assert(client.encryptionEnabled,
          "die if client does not support encryption");

      return CMCLoginStatus(
        accessToken: status.accessToken!,
        deviceId: status.deviceId!,
        homeServer: status.homeServer!,
        userId: status.userId!,
        client: client,
      );
    } on MatrixException catch (e) {
      throw LoginError(e.errorMessage);
    }
  }

  void validateUsername(String? username) {
    if (username == null) {
      throw LoginError("Empty Matrix ID");
    }

    if (username.isValidMatrixId) {
      return null;
    } else {
      throw LoginError("Invalid Matrix ID");
    }
  }
}
