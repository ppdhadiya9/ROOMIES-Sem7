final placeholderphotourl =
    "https://firebasestorage.googleapis.com/v0/b/fir-auth-35cac.appspot.com/o/Roomphoto%2F1616577499518?alt=media&token=e93e4820-eac2-401e-8346-01b31e6714e8";

final Function passwordValidation = (value) {
  if (value == '') {
    return "This Field is Required";
  } else if (value.length < 6) {
    return "Input length is Too Short";
  }
  return null;
};

final Function repasswordValidation = (value1, value2) {
  if (value1 != value2 && value2.length < 6) {
    return "Both passsword must be same";
  }
  return null;
};

final Function repasswordValidation2 = (value) {
  if (value == '') {
    return "This Field is Required";
  } else if (value.length < 6) {
    return "Input length is Too Short";
  }
  return null;
};

final RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

final Function emailValidation = (value) {
  if (value == '') {
    return "This Field is Required";
  } else if (!emailValidatorRegExp.hasMatch(value)) {
    return "Enter valid Email";
  }
  return null;
};

final Function commonValidation = (value) {
  if (value == '') {
    return "This Field is Required";
  }
  return null;
};
