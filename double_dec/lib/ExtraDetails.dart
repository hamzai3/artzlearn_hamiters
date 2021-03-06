
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
class ExtraDetails {

  getWhiteColor() {
    return new Color.fromRGBO(255, 255, 255, 0.9);
  }getBlackColor() {
    return  Colors.black;
  }
  getBlueColor(){
     return new Color(0xff3278ce);
  }
  getBlueColorOpc(opc){
     return new Color(0xff3278ce).withOpacity(opc);
  }
  getYellow(){
    return new Color(0xfff1b700);
  }
  getDarkBrownColor() {
    return new Color(0xffA33100);
  } 
  getBrownColor() {
    return new Color(0xffE7D2B1);
  }
  getGreyColor(){
    return new Color.fromRGBO(255, 255, 255, 0.9);
  }
  getURL(){
    return 'http://artzlearn.com/app-api/rest_api.php';
  }
  getDivider(height){
    return Divider(height:height ,color: Colors.transparent,);
  }
  Future<bool> setshared(String name, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(name, value);
    pref.commit();
    return true;
  }
  Future<bool> setsharedList(String name, List value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList(name, value);
    pref.commit();
    return true;
  }
  Future<String> getshared(String skey) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(skey).toString();
  } 
}