import 'package:flutter/material.dart';
import 'package:myshop/sdk/invoice.dart';
import 'package:myshop/sdk/sdk_response.dart';

class InvoiceForm extends StatefulWidget {
  final void Function(SdkResponse response)? postSave;
  const InvoiceForm({super.key, this.postSave});

  @override
  State<StatefulWidget> createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  final _formKey = GlobalKey<FormState>();
  var customerNameController = TextEditingController();
  var date = DateTime.now();
  var invoiceNumberController = TextEditingController();

  void save() async {
    var createInvoice = CreateInvoice(
      customerName: customerNameController.text,
      date: date,
      invoiceNumber: int.parse(invoiceNumberController.text),
    );
    var response = await createInvoice.create();
    if (widget.postSave != null) {
      widget.postSave!(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text("Create Invoice"),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Customer Name",
              ),
              controller: customerNameController,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: InputDatePickerFormField(
              fieldLabelText: "Date",
              firstDate: DateTime(2024),
              lastDate: DateTime(2030),
              initialDate: date,
              keyboardType: TextInputType.datetime,
              onDateSubmitted: (value) {
                setState(() {
                  date = value;
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: invoiceNumberController,
              decoration: const InputDecoration(
                labelText: "Invoice Number",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                save();
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}
