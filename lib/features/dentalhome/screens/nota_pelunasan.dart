import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/nota_provider.dart';
import 'pembayaran_berhasil_pelunasan.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class NotaPelunasanScreen extends StatefulWidget {
  final int idTransaksi;

  const NotaPelunasanScreen({super.key, required this.idTransaksi});

  @override
  State<NotaPelunasanScreen> createState() => _NotaPelunasanScreenState();
}

class _NotaPelunasanScreenState extends State<NotaPelunasanScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<InvoiceProvider>(context, listen: false)
        .loadInvoice(widget.idTransaksi);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InvoiceProvider>(context);

    if (provider.loading || provider.invoice == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    final inv = provider.invoice!;

    return Scaffold(
      backgroundColor: Color(0xFF141218),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: Text("Rincian Tagihan Anda", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _header(inv),
            SizedBox(height: 20),
            _detail(inv),
            SizedBox(height: 20),
            _metode(provider),
            SizedBox(height: 20),
            _btnBayar(provider),
          ],
        ),
      ),
    );
  }

  Widget _header(inv) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Nama Pasien", inv.namaPasien),
          SizedBox(height: 8),
          _row("ID Invoice", inv.invoiceId),
          SizedBox(height: 8),
          _row("Tanggal", inv.tanggal),
        ],
      ),
    );
  }

  Widget _detail(inv) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rincian Perawatan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),

          ...inv.items.map((i) => _row(i.nama, "Rp ${i.harga}")),

          Divider(color: Colors.white24),
          _row("Subtotal", "Rp ${inv.subtotal}"),
          _row("Uang Booking", "-Rp ${inv.booking}"),

          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Akhir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("Rp ${inv.totalAkhir}", style: TextStyle(color: Colors.amber, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metode(provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pilih Metode Pelunasan", style: TextStyle(color: Colors.white70)),
        SizedBox(height: 10),
        Row(
          children: [
            _metodeBtn(provider, "Tunai"),
            SizedBox(width: 10),
            _metodeBtn(provider, "Transfer"),
            SizedBox(width: 10),
            _metodeBtn(provider, "E-wallet"),
          ],
        )
      ],
    );
  }

  Widget _metodeBtn(provider, String metode) {
    final aktif = provider.metodePembayaran == metode;

    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setMetode(metode),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: aktif ? Colors.amber.withOpacity(0.2) : Colors.transparent,
            border: Border.all(color: aktif ? Colors.amber : Colors.white24),
          ),
          child: Center(
            child: Text(metode, style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _btnBayar(provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: StadiumBorder(),
        ),
        onPressed: () async {
          bool ok = await provider.bayar(widget.idTransaksi);

          if (ok) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PembayaranBerhasilScreen(invoice: provider.invoice!)),
            );
          }
        },
        child: Text("Selesaikan Pembayaran", style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _row(String l, String r) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: TextStyle(color: Colors.white70)),
        Text(r, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Color(0xFF1E1B22),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
