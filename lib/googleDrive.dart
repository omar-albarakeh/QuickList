import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class GoogleDriveService {
  static const _scopes = [drive.DriveApi.driveFileScope];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
  );

  Future<drive.DriveApi?> authenticate() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      print("Sign in failed");
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthClient client = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken(
          "Bearer",
          googleAuth.accessToken!,
          DateTime.now().add(Duration(hours: 1)),
        ),
        googleAuth.idToken,
        _scopes,
      ),
    );

    return drive.DriveApi(client);
  }

  Future<void> uploadFile(File file) async {
    final drive.DriveApi? driveApi = await authenticate();
    if (driveApi == null) return;

    var driveFile = drive.File();
    driveFile.name = file.path.split('/').last;

    await driveApi.files.create(
      driveFile,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
    );
    print("File uploaded successfully!");
  }

  Future<void> listFiles() async {
    final drive.DriveApi? driveApi = await authenticate();
    if (driveApi == null) return;

    var fileList = await driveApi.files.list();
    fileList.files?.forEach((file) {
      print("File: ${file.name}, ID: ${file.id}");
    });
  }
}
