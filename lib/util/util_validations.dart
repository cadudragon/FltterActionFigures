class UtilValidations{
  
  static bool isEmail(String input){
  return RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(input);
  }

   static bool isDecimal(String input){
  return RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(input);
  }
}