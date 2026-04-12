import 'package:joss_app/models/user/user_model.dart';

class AppData {

  static String userToken = "";
  static int chatRefresh = 10;
  static bool kIsWeb = false;
  static User user = User();
  static var uriHtpp = useSSL ? Uri.https : Uri.http;
  static String version = "1.0.2";
  static bool isInOtpProcess = false;


  static bool useSSL = false;
  static String apiDomain = "http://10.211.55.5/eAssistToolsAPI/";
  static String prefixEndPoint = "/eAssistToolsAPI";
  static String httpAuthority = "10.211.55.5";


  // static bool useSSL = true;
  // static String apiDomain =
  //     "http${useSSL ? "s" : ""}://eassist-re.jpsre.co.id/joss_api/";
  // static String prefixEndPoint = "joss_api";
  // static String httpAuthority = "eassist-re.jpsre.co.id";


  // static bool useSSL = false;
  // static String apiDomain = "http://10.0.2.2/eAssistToolsAPI/";
  // static String prefixEndPoint = "/eAssistToolsAPI";
  // static String httpAuthority = "10.0.2.2";


  // static bool useSSL = false;
  // static String apiDomain =
  //     "http${useSSL ? "s" : ""}://eassisttoolsapi.smartsoft-id.com/";
  // static String prefixEndPoint = "";
  // static String httpAuthority = "eassisttoolsapi.smartsoft-id.com";



  // static bool useSSL = false;
  // static String httpAuthority = "localhost";
  // static String prefixEndPoint = "/eAssistToolsAPI/";
  // static String apiDomain = "http://localhost/eAssistToolsAPI/";

  // static bool useSSL = false;
  // static String apiDomain = "http://localhost:1234/";
  // static String prefixEndPoint = "/eAssistToolsAPI";
  // static String httpAuthority = "localhost:1234";

  // static bool useSSL = false;
  // static String apiDomain =
  //     "http${useSSL ? "s" : ""}://eassisttoolsapi.smartsoft-id.com/";
  // static String prefixEndPoint = "";
  // static String httpAuthority = "eassisttoolsapi.smartsoft-id.com";

  // static bool useSSL = false;
  // static String httpAuthority = "localhost";
  // static String prefixEndPoint = "/eAssistToolsAPI/";
  // static String apiDomain = "http://localhost/eAssistToolsAPI/";

  // static bool useSSL = false;
  // static String apiDomain = "http${useSSL ? "s" : ""}://108.181.199.145/eAssistToolsAPI/";
  // static String prefixEndPoint = "/eAssistToolsAPI";
  // static String httpAuthority = "108.181.199.145";

  // static bool useSSL = false;
  // static String apiDomain = "http${useSSL ? "s" : ""}://locahost:/eAssistToolsAPI/";
  // static String prefixEndPoint = "/eAssistToolsAPI";
  // static String httpAuthority = "108.181.199.145";

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