import 'package:joss_app/models/user/user_model.dart';

class AppData {
  
  static String userToken = "";
  static int chatRefresh = 10;
  static bool kIsWeb = false;
  static User user = User();
  static var uriHtpp = useSSL ? Uri.https : Uri.http;
  static String version = "1.0.2";
  static bool isInOtpProcess = false;

  // static bool useSSL = false;
  // static String apiDomain = "http://10.0.2.2/eAssistToolsAPI/";
  // static String prefixEndPoint = "/eAssistToolsAPI";
  // static String httpAuthority = "10.0.2.2";



  static bool useSSL = false;
  static String apiDomain =
      "http${useSSL ? "s" : ""}://eassisttoolsapi.smartsoft-id.com/";
  static String prefixEndPoint = "";
  static String httpAuthority = "eassisttoolsapi.smartsoft-id.com";

//

// static bool useSSL = false;
// static String apiDomain = "http://localhost:57657/";
// static String prefixEndPoint = "/eAssistToolsAPI";
<<<<<<< HEAD
// static String httpAuthority = "localhost:1234";
//
=======
// static String httpAuthority = "localhost:57657";

>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398

/*
static bool useSSL = false;
static String apiDomain = "http${useSSL ? "s" : ""}://216.172.109.8/eAssistToolsAPI/";
static String prefixEndPoint = "/eAssistToolsAPI";
static String httpAuthority = "216.172.109.8";
*/



/*
  static bool useSSL = true;
  static String apiDomain = "http${useSSL ? "s" : ""}://eassisttoolsapi.smartsoft-id.com/";
  static String prefixEndPoint = "";
  static String httpAuthority = "eassisttoolsapi.smartsoft-id.com";
*/

  static Map<String, String> httpHeaders = <String, String>{
    'Content-Type': 'application/json; odata=verbos',
    'Accept': 'application/json; odata=verbos',
    'Authorization': 'Bearer ${AppData.userToken}'
  };

}
