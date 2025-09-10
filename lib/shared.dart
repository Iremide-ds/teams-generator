import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final isLoading = ValueNotifier(false);

void toggleLoadingOn() {
  isLoading.value = true;
}

void toggleLoadingOff() {
  isLoading.value = false;
}

String? notEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field can not be empty';
  }

  return null;
}

final class OnlyIntInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final numberValue = num.tryParse(newValue.text);

    if (numberValue == null ||
        numberValue.isNegative ||
        isDecimal(numberValue)) {
      return oldValue;
    }

    return newValue;
  }
}

bool isDecimal(num value) {
  return (value % 1) != 0;
}
