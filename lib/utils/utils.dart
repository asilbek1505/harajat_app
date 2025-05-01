import'dart:io';
import 'package:intl/intl.dart';


class Utils {
  static Future<Map<String, String>> deviseParams() async {
    Map<String, String> params = {};
    // var getDeviceId = await DeviceInfoPlugin();
    String fmcToken = '';
    // if (Platform.isIOS) {
    //   var iosDeviseInfo = await getDeviceId.iosInfo;
    //   params.addAll({
    //     'devise_id': iosDeviseInfo.identifierForVendor!,
    //     'devise_type': 'IOS',
    //     'devsie_token': fmcToken,
    //   });
    // } else if(Platform.isAndroid){
    //   var androidDeviseInfo = await getDeviceId.iosInfo;
    //   params.addAll({
    //     'devise_id': androidDeviseInfo.identifierForVendor!,
    //     'devise_type': 'Android',
    //     'devsie_token': fmcToken,
    //   });
    // }else {
    //   params;
    // }
    return params;
  }

  static String currentDate(){
    DateTime now=DateTime.now();
    String currentDateTime=DateFormat('yyyy MM dd hh:mm').format(now).toString();
    return currentDateTime;
  }
}
