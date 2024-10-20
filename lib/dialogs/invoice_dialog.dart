import 'package:flutter/material.dart';
import 'package:myshop/dialogs/edit_invoice_item_dialog.dart';
import 'package:myshop/forms/invoice_item_form.dart';
import 'package:myshop/sdk/invoice.dart';
import 'package:myshop/sdk/sdk_response.dart';

class InvoiceDialog extends StatefulWidget {
  final String invoiceNumber;
  final void Function(SdkResponse<Invoice> response) postDelete;
  const InvoiceDialog({
    super.key,
    required this.invoiceNumber,
    required this.postDelete,
  });

  @override
  State<StatefulWidget> createState() => _InvoiceDialogState();
}

class _InvoiceDialogState extends State<InvoiceDialog> {
  Future<Invoice?> invoice = Future.value(null);

  @override
  void initState() {
    super.initState();
    invoice = Invoice.fromInvoiceNumber(widget.invoiceNumber);
  }

  void reload() {
    setState(() {
      invoice = Invoice.fromInvoiceNumber(widget.invoiceNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Invoice #${widget.invoiceNumber}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            FutureBuilder(
              future: invoice,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return renderInvoice(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return const Text("Loading...");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget renderInvoice(Invoice invoice) {
    var rows = invoice.invoiceItems
        .map((invoiceItem) => DataRow(
              cells: [
                DataCell(
                  Text(invoiceItem.quantity.toString()),
                  onTap: () {
                    showEditItemDialog(invoiceItem);
                  },
                ),
                DataCell(
                  Text(invoiceItem.description),
                  onTap: () {
                    showEditItemDialog(invoiceItem);
                  },
                ),
                DataCell(
                  Text(invoiceItem.unitPrice.toString()),
                  onTap: () {
                    showEditItemDialog(invoiceItem);
                  },
                ),
                DataCell(Text(invoiceItem.amount.toString())),
              ],
            ))
        .toList();
    rows.add(DataRow(
      cells: [
        const DataCell(Text("")),
        const DataCell(Text("")),
        const DataCell(Text("")),
        DataCell(Text(invoice.total.toString())),
      ],
    ));
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text("Name: ${invoice.customerName}"),
          trailing: Text("No. ${invoice.invoiceNumber}"),
        ),
        ListTile(
          title: Text("Payment Method: ${invoice.paymentMethod}"),
          trailing: Text("Date. ${invoice.date}"),
        ),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Qty"), numeric: true),
                DataColumn(label: Text("Description")),
                DataColumn(label: Text("@"), numeric: true),
                DataColumn(label: Text("Amount (K)"), numeric: true),
              ],
              rows: rows,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            showAddItemDialog();
          },
          child: const Text("Add Item"),
        ),
        ElevatedButton(
          onPressed: () {
            deleteInvoice(invoice);
          },
          child: const Text("Delete Invoice"),
        ),
      ],
    );
  }

  void deleteInvoice(Invoice invoice) {
    invoice.delete().then((response) {
      widget.postDelete(response);
    });
  }

  void showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text("Add Item"),
                ),
                AddInvoiceItemForm(
                  invoiceNumber: widget.invoiceNumber,
                  postSave: (response) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(response.message),
                    ));
                    if (response.success) {
                      Navigator.pop(context);
                      reload();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEditItemDialog(InvoiceItem invoiceItem) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: EditInvoiceItemDialog(
            invoiceItem: invoiceItem,
            postSave: (response) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(response.message),
              ));
              if (response.success) {
                Navigator.pop(context);
                reload();
              }
            },
            postDelete: (response) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(response.message),
              ));
              if (response.success) {
                Navigator.pop(context);
                reload();
              }
            },
          ),
        );
      },
    );
  }
}
