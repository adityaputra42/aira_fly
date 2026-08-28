class Endpoint {
  // ===== AUTH ===== //
  static const forgotPassword = "auth/forgot-password";
  static const login = "auth/login";
  static const getUser = "auth/me";
  static const updateUser = "auth/me";
  static const refreshToken = "auth/refresh-token";
  static const register = "auth/register";
  static const resetPassword = "auth/reset-password";

  // ===== Ancillaries ===== //
  static const getAncillariesForFlight = "ancillaries/flight/";
  static const getAncillaryById = "ancillaries/";
  static const getAncillariesCategory = "ancillaries/categories";
  static const getAncillaryCategoryById = "ancillaries/categories/";
  static const ancillariesPurchase = "ancillaries/purchases";
  static const getAncillariesPurchaseByPnr = "ancillaries/purchases/pnr/";

  // ===== Booking ===== //
  static const pnr = "bookings/pnrs";

  // ===== Aircrafts ===== //
  static const getAircrafts = "flights/aircrafts";
  static const getAircraftsSeat = "/seats";

  // ===== Airports ===== //
  static const getAirport = "flights/airports";

  // ===== Fare classes ===== //
  static const getFareClasses = "flights/fare-classes";

  // ===== Flight ===== //
  static const flightSearch = "flights/search";
  static const flightInstances = "flights/instances";

  // ===== Checkin ===== //
  static const checkin = "checkin";
  static const boardingPass = "checkin/borading-pass";

  // ===== Wallet ===== //
  static const walletBalance = "wallet/balance";
  static const walletTransaction = "wallet/transactions";
  static const walletTopup = "wallet/topup";
}
