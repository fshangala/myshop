import 'package:flutter/material.dart';
import 'package:myshop/sdk/invoice.dart';
import 'package:myshop/sdk/sdk_response.dart';

class AddInvoiceItemForm extends StatefulWidget {
  final String invoiceNumber;
  final void Function(SdkResponse<InvoiceItem> response) postSave;
  const AddInvoiceItemForm({
    super.key,
    required this.invoiceNumber,
    required this.postSave,
  });

  @override
  State<StatefulWidget> createState() => _AddInvoiceItemFormState();
}

class _AddInvoiceItemFormState extends State<AddInvoiceItemForm> {
  final _formKey = GlobalKey<FormState>();
  var quantityController = TextEditingController();
  var descriptionController = TextEditingController();
  var unitPriceController = TextEditingController();

  void addItem() {
    InvoiceItem.create(
      invoiceNumber: widget.invoiceNumber,
      quantity: int.parse(quantityController.text),
      description: descriptionController.text,
      unitPrice: double.parse(unitPriceController.text),
    ).then((response) {
      if (response.success) {
        widget.postSave(response);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              keyboardType: TextInputType.text,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: unitPriceController,
              decoration: const InputDecoration(labelText: "Unit Price"),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                addItem();
              },
              child: const Text("Add"),
            ),
          )
        ],
      ),
    );
  }
}
