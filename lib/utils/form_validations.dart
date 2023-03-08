bool isValidEmail(String? s) {
  if (s == null || s == "") return false;
  final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return emailRegExp.hasMatch(s);
}

bool isValidName(String? s) {
  if (s == null || s == "") return false;
  final nameRegExp = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');
  return nameRegExp.hasMatch(s);
}

bool isValidPassword(String? s) {
  if (s == null || s == "") return false;
  final passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  return passwordRegExp.hasMatch(s);
}

bool isValidPhone(String? s) {
  if (s == null || s == "") return false;
  final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
  return phoneRegExp.hasMatch(s);
}
