import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/utils/format.dart';
import 'package:flutter_klinik_gigi/providers/payment_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/method_button.dart';
import 'rincian_success.dart';

class PaymentDetailScreen extends StatelessWidget {
  const PaymentDetailScreen({super.key, required Map<String, Object> transaction, required invoiceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Rincian Tagihan Anda"),
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, prov, _) {
          final invoice = prov.invoice;

          if (invoice == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ---------- HEADER ----------
                  Card(
                    color: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow("Nama Pasien", invoice.patientName),
                          const SizedBox(height: 8),
                          _infoRow("ID Invoice", invoice.invoiceId),
                          const SizedBox(height: 8),
                          _infoRow("Tanggal", formatDate(invoice.date)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ---------- RINCIAN ----------
                  Card(
                    color: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            "Rincian Perawatan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),

                          ...invoice.items.map(
                            (item) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.name),
                                Text(formatCurrency(item.price)),
                              ],
                            ),
                          ),

                          const Divider(color: Colors.white30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Akhir",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                formatCurrency(invoice.total),
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Pilih Metode Pelunasan",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),

                  /// ---------- METHOD BUTTON ----------
                  Row(
                    children: [
                      Expanded(
                        child: MethodButton(
                          label: "Transfer",
                          icon: Icons.account_balance,
                          active: prov.paymentMethod == "Transfer",
                          onTap: () => prov.setMethod("Transfer"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MethodButton(
                          label: "E-wallet",
                          icon: Icons.qr_code,
                          active: prov.paymentMethod == "E-wallet",
                          onTap: () => prov.setMethod("E-wallet"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ---------- BUTTON BAYAR ----------
                  ElevatedButton(
                    onPressed: prov.isLoading
                        ? null
                        : () async {
                            try {
                              final ok = await prov.pay();
                              if (ok) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const PaymentSuccessScreen(),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Pembayaran gagal: $e"),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: prov.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Selesaikan Pembayaran",
                            style: TextStyle(color: Colors.black),
                          ),
                  ),

                  const SizedBox(height: 12),

                  const Center(
                    child: Text(
                      "Unduh Invoice",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// ---------- HELPER ----------
  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
