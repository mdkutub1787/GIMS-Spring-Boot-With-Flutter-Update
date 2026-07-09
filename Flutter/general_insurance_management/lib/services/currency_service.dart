class CurrencyService {
  // Simple conversion logic from your previous project
  double convertUsdToTk(double usd, double rate) {
    return usd * rate;
  }

  double convertTkToUsd(double tk, double rate) {
    if (rate == 0) return 0;
    return tk / rate;
  }
}
