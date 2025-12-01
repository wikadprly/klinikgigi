import 'package:flutter/material.dart';
import '../core/services/promo_service.dart';
import '../core/models/promo_model.dart';

class PromoProvider with ChangeNotifier {
  List<PromoModel> _promos = [];
  bool _isLoading = false;

  List<PromoModel> get promos => _promos;
  bool get isLoading => _isLoading;

  final PromoService _promoService = PromoService();

  Future<void> fetchPromos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _promos = await _promoService.fetchPromos();
    } catch (e) {
      _promos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addPromo(PromoModel promo) {
    _promos.add(promo);
    notifyListeners();
  }

  void removePromo(int id) {
    _promos.removeWhere((promo) => promo.id == id);
    notifyListeners();
  }
}