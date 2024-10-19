import 'package:flutter/material.dart';
import 'package:myshop/forms/invoice_item_form.dart';
import 'package:myshop/sdk/invoice.dart';

class EditInvoiceItemDialog extends StatefulWidget {
  final InvoiceItem invoiceItem;

  const EditInvoiceItemDialog({
    super.key,
    required this.invoiceItem,
  });

  @override
  State<StatefulWidget> createState() => _EditInvoiceItemDialogState();
}

class _EditInvoiceItemDialogState extends State<EditInvoiceItemDialog> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InvoiceItemForm(
            invoiceItem: widget.invoiceItem,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Delete"),
            ),
          ),
        ],
      ),
    );
  }
}
