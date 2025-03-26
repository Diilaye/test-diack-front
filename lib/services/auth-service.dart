import 'package:form/models/user-model.dart';
import 'package:form/utils/requette-by-dii.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

String yourToken = "DIIKAANEDEV@SIMPLON.DII";

class AuthService {
  Future<UserModel?> auth(Map<String, dynamic> body) async {
    return await postResponse(url: '/users/auth', body: body)
        .then((value) async {
      print(value);

      if (value['status'] == 200) {
        UserModel user = UserModel.fromJson(value['body']['data']);
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('type', user.type!);
          prefs.setString('token', user.token!);
        });
        return user;
      } else {
        return null;
      }
    });
  }

  Future<String?> authSonde(Map<String, dynamic> body) async {
    print("body");
    print(body);
    return await postResponse(url: '/users/auth/sonde', body: body)
        .then((value) async {
      print(value);

      if (value['status'] == 200) {
        await SharedPreferences.getInstance().then((prefs) {
          Map<String, dynamic> decodedToken =
              JwtDecoder.decode(value['body']['data']['token']);
          prefs.setString('type', decodedToken['role_user']);
          prefs.setString('token', value['body']['data']['token']);
        });
        return 'reussi';
      } else {
        return null;
      }
    });
  }

  Future<UserModel?> store(Map<String, dynamic> body) async {
    return await postResponse(url: '/users', body: body).then((value) async {
      if (value['status'] == 201) {
        return UserModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<UserModel?> upadte(String id, Map<String, dynamic> body) async {
    return await putResponse(url: '/users/$id', body: body).then((value) async {
      print(value);
      if (value['status'] == 200) {
        return UserModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<UserModel?> getAuth() async {
    return await getResponse(url: '/users/auth').then((value) async {
      if (value['status'] == 200) {
        UserModel user = UserModel.fromJson(value['body']['data']);
        return user;
      } else {
        return null;
      }
    });
  }

  Future<List<UserModel>> getUser() async {
    return await getResponse(url: '/users/').then((value) async {
      if (value['status'] == 200) {
        return UserModel.fromList(data: value['body']['data']);
      } else {
        return [];
      }
    });
  }
}
