import 'package:myshop/sdk/sdk_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateInvoice {
  String customerName;
  DateTime date;
  int invoiceNumber;

  CreateInvoice({
    this.customerName = "",
    required this.date,
    this.invoiceNumber = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      "customerName": customerName,
      "date": date,
      "invoiceNumber": invoiceNumber
    };
  }

  Future<SdkResponse> create() async {
    var sharedPref = await SharedPreferences.getInstance();
    var invoices = sharedPref.getStringList("invoices") ?? [];
    if (invoices.any((elem) {
      return elem == invoiceNumber.toString();
    })) {
      return SdkResponse(success: false, message: "Invoice exists");
    } else {
      sharedPref.setString("$invoiceNumber.customerName", customerName);
      sharedPref.setString("$invoiceNumber.date", date.toString());
      invoices.add(invoiceNumber.toString());
      sharedPref.setStringList("invoices", invoices);
      return SdkResponse(
        success: true,
        message: "Invoice created!",
        data: invoiceNumber.toString(),
      );
    }
  }
}
