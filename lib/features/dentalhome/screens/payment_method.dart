import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = "BCA";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1D),
        elevation: 0,
        leading: IconButton(
  icon: const Icon(Icons.arrow_back, color: Colors.white),
  onPressed: () {
    Navigator.pop(context);
  },
),

        title: const Text("Pembayaran Booking",
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            const Text(
              "Pembayaran",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Mohon lakukan pembayaran\nPilih metode pembayaran untuk menyelesaikan booking",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Drg. Amanda\nSpesialis Ortho",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Colors.amber, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "Senin, 03 November 2025\n17.00 - 18.00",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rowPayment("Biaya Reservasi", "Rp95.000"),
                  const SizedBox(height: 6),
                  rowPayment("Biaya Jarak", "Rp5.000"),
                  const Divider(color: Colors.grey),
                  rowPayment("Total Pembayaran", "Rp100.000", isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Metode Pembayaran",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),

            
            paymentMethod(
              title: "BCA Virtual Account",
              value: "BCA",
              iconWidget: Image.asset(
                'assets/bca.png',
                width: 30,
                height: 30,
              ),
            ),

           
           paymentMethod(
  title: "GoPay",
  value: "GOPAY",
  iconWidget: Image.asset(
    'assets/gopay.png',   
    width: 30,
    height: 30,
  ),
),


            
            
 paymentMethod(
  title: "ShopeePay",
  value: "Shopee",
  iconWidget: Image.asset(
    'assets/shopeepay.png',
    width: 30,
    height: 30,
  ),
),


            const SizedBox(height: 25),

            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  
                  if (selectedMethod.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pilih metode pembayaran dulu ya!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF2A2A2E),
                        title: const Text(
                          "Konfirmasi Pembayaran",
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          "Anda memilih metode:\n\n$selectedMethod\n\nLanjutkan pembayaran?",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal",
                                style: TextStyle(color: Colors.amber)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                            ),
                            onPressed: () {
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Pembayaran Berhasil!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Text(
                              "Ya, Bayar",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  "Bayar",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  
  Widget rowPayment(String left, String right, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
              color: Colors.grey,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          right,
          style: TextStyle(
            color: Colors.white,
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  
  Widget paymentMethod({
    required String title,
    required String value,
    required Widget iconWidget,
  }) {
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2E),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: iconWidget,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Radio(
              value: value,
              groupValue: selectedMethod,
              onChanged: (v) => setState(() => selectedMethod = v.toString()),
              activeColor: Colors.amber,
            )
          ],
        ),
      ),
    );
  }
}
