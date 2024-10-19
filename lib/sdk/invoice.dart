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

class InvoiceItem {
  String invoiceNumber;
  String invoiceItemHash;
  int quantity;
  String description;
  double unitPrice;

  InvoiceItem({
    required this.invoiceNumber,
    required this.invoiceItemHash,
    required this.quantity,
    required this.description,
    required this.unitPrice,
  });

  double get amount {
    return quantity * unitPrice;
  }

  static Future<InvoiceItem?> fromInvoiceItemHash({
    required String invoiceNumber,
    required String invoiceItemHash,
  }) async {
    var sharedPref = await SharedPreferences.getInstance();
    var quantity =
        sharedPref.getInt("$invoiceNumber.$invoiceItemHash.quantity");
    var description =
        sharedPref.getString("$invoiceNumber.$invoiceItemHash.description");
    var unitPrice =
        sharedPref.getDouble("$invoiceNumber.$invoiceItemHash.unitPrice");
    return InvoiceItem(
      invoiceNumber: invoiceNumber,
      invoiceItemHash: invoiceItemHash,
      quantity: quantity!,
      description: description!,
      unitPrice: unitPrice!,
    );
  }

  static Future<SdkResponse<InvoiceItem>> create({
    required String invoiceNumber,
    required int quantity,
    required String description,
    required double unitPrice,
  }) async {
    var sharedPref = await SharedPreferences.getInstance();
    var invoiceItemHash = description.replaceAll(" ", "_").toLowerCase();
    var invoiceItems =
        sharedPref.getStringList("$invoiceNumber.invoiceItems") ?? [];
    sharedPref.setInt("$invoiceNumber.$invoiceItemHash.quantity", quantity);
    sharedPref.setString(
        "$invoiceNumber.$invoiceItemHash.description", description);
    sharedPref.setDouble(
        "$invoiceNumber.$invoiceItemHash.unitPrice", unitPrice);
    invoiceItems.add(invoiceItemHash);
    sharedPref.setStringList("$invoiceNumber.invoiceItems", invoiceItems);
    var invoiceItem = await InvoiceItem.fromInvoiceItemHash(
      invoiceNumber: invoiceNumber,
      invoiceItemHash: invoiceItemHash,
    );
    return SdkResponse(
      success: true,
      message: "Invoice item successfully added!",
      data: invoiceItem,
    );
  }

  Future<SdkResponse<InvoiceItem>> save() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setInt("$invoiceNumber.$invoiceItemHash.quantity", quantity);
    sharedPref.setString(
        "$invoiceNumber.$invoiceItemHash.description", description);
    sharedPref.setDouble(
        "$invoiceNumber.$invoiceItemHash.unitPrice", unitPrice);
    var invoiceItem = await InvoiceItem.fromInvoiceItemHash(
      invoiceNumber: invoiceNumber,
      invoiceItemHash: invoiceItemHash,
    );
    return SdkResponse(
      success: true,
      message: "Invoice item successfully updated!",
      data: invoiceItem,
    );
  }

  Future<SdkResponse<InvoiceItem?>> delete() async {
    var sharedPref = await SharedPreferences.getInstance();
    var invoiceItems =
        sharedPref.getStringList("$invoiceNumber.invoiceItems") ?? [];
    var newItems =
        invoiceItems.where((value) => value != invoiceItemHash).toList();
    sharedPref.remove("$invoiceNumber.$invoiceItemHash.quantity");
    sharedPref.remove("$invoiceNumber.$invoiceItemHash.description");
    sharedPref.remove("$invoiceNumber.$invoiceItemHash.unitPrice");
    sharedPref.setStringList("$invoiceNumber.invoiceItems", newItems);
    return SdkResponse(
      success: true,
      message: "Invoice item successfully deleted!",
    );
  }
}

class Invoice {
  String customerName;
  DateTime date;
  int invoiceNumber;
  String paymentMethod;
  List<InvoiceItem> invoiceItems = [];

  Invoice({
    required this.customerName,
    required this.date,
    required this.invoiceNumber,
    required this.paymentMethod,
  });

  double get total {
    var amount = 0.0;
    for (var invoiceItem in invoiceItems) {
      amount += invoiceItem.amount;
    }
    return amount;
  }

  static Future<Invoice?> fromInvoiceNumber(String invoiceNumber) async {
    var sharedPref = await SharedPreferences.getInstance();
    var customerName =
        sharedPref.getString("$invoiceNumber.customerName") ?? "";
    var dateString = sharedPref.getString("$invoiceNumber.date") ?? "";
    var date = DateTime.parse(dateString);
    var paymentMethod =
        sharedPref.getString("$invoiceNumber.paymentMethod") ?? "";
    var invoice = Invoice(
      customerName: customerName,
      date: date,
      invoiceNumber: int.parse(invoiceNumber),
      paymentMethod: paymentMethod,
    );
    var invoiceItems =
        await Invoice.getInvoiceItems(invoiceNumber: invoiceNumber);
    invoice.invoiceItems = invoiceItems;
    return invoice;
  }

  static Future<List<Invoice?>> getInvoices() async {
    var sharedPref = await SharedPreferences.getInstance();
    var invoiceNumbers = sharedPref.getStringList("invoices") ?? [];

    var invoices = <Invoice>[];
    for (var invoiceNumber in invoiceNumbers) {
      var invoice = await Invoice.fromInvoiceNumber(invoiceNumber);
      if (invoice != null) {
        invoices.add(invoice);
      }
    }
    return invoices;
  }

  static Future<List<InvoiceItem>> getInvoiceItems(
      {required String invoiceNumber}) async {
    var sharedPref = await SharedPreferences.getInstance();
    var invoiceItems =
        sharedPref.getStringList("$invoiceNumber.invoiceItems") ?? [];
    var invoiceItemsList = <InvoiceItem>[];
    for (var invoiceItemHash in invoiceItems) {
      var invoiceItem = await InvoiceItem.fromInvoiceItemHash(
        invoiceNumber: invoiceNumber,
        invoiceItemHash: invoiceItemHash,
      );
      if (invoiceItem != null) {
        invoiceItemsList.add(invoiceItem);
      }
    }
    return invoiceItemsList;
  }
}
