import 'package:flutter/material.dart';
import 'package:myshop/forms/invoice_item_form.dart';
import 'package:myshop/sdk/invoice.dart';
import 'package:myshop/sdk/sdk_response.dart';

class EditInvoiceItemDialog extends StatefulWidget {
  final InvoiceItem invoiceItem;
  final void Function(SdkResponse<InvoiceItem> response) postSave;
  final void Function(SdkResponse<InvoiceItem?> response) postDelete;

  const EditInvoiceItemDialog({
    super.key,
    required this.invoiceItem,
    required this.postSave,
    required this.postDelete,
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
            postSave: (response) {
              widget.postSave(response);
            },
            postDelete: (response) {
              widget.postDelete(response);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                widget.invoiceItem.delete().then((response) {
                  widget.postDelete(response);
                });
              },
              child: const Text("Delete"),
            ),
          ),
        ],
      ),
    );
  }
}
