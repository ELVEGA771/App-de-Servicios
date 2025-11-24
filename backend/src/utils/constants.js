// User types
const USER_TYPES = {
  CLIENT: 'cliente',
  COMPANY: 'empresa',
  EMPLOYEE: 'empleado',
  ADMIN: 'admin'
};

// User status
const USER_STATUS = {
  ACTIVE: 'activo',
  INACTIVE: 'inactivo',
  SUSPENDED: 'suspendido'
};

// Service status
const SERVICE_STATUS = {
  AVAILABLE: 'disponible',
  UNAVAILABLE: 'no_disponible',
  SOLD_OUT: 'agotado'
};

// Contract status
const CONTRACT_STATUS = {
  PENDING: 'pendiente',
  CONFIRMED: 'confirmado',
  IN_PROGRESS: 'en_proceso',
  COMPLETED: 'completado',
  CANCELLED: 'cancelado',
  REJECTED: 'rechazado'
};

// Payment status
const PAYMENT_STATUS = {
  PENDING: 'pendiente',
  COMPLETED: 'completado',
  FAILED: 'fallido',
  REFUNDED: 'reembolsado'
};

// Payment methods
const PAYMENT_METHODS = {
  CREDIT_CARD: 'tarjeta_credito',
  DEBIT_CARD: 'tarjeta_debito',
  CASH: 'efectivo',
  TRANSFER: 'transferencia',
  PAYPAL: 'paypal',
  OTHER: 'otro'
};

// Coupon types
const COUPON_TYPES = {
  PERCENTAGE: 'porcentaje',
  FIXED_AMOUNT: 'monto_fijo'
};

// Coupon applicability
const COUPON_APPLICABILITY = {
  ALL: 'todos',
  CATEGORY: 'categoria',
  SPECIFIC_SERVICE: 'servicio_especifico'
};

// Conversation status
const CONVERSATION_STATUS = {
  OPEN: 'abierta',
  CLOSED: 'cerrada',
  ARCHIVED: 'archivada'
};

// Message types
const MESSAGE_TYPES = {
  TEXT: 'texto',
  IMAGE: 'imagen',
  FILE: 'archivo',
  AUDIO: 'audio'
};

// Notification types
const NOTIFICATION_TYPES = {
  NEW_MESSAGE: 'nuevo_mensaje',
  STATUS_CHANGE: 'cambio_estado',
  NEW_COUPON: 'nuevo_cupon',
  RATING: 'calificacion',
  PAYMENT: 'pago',
  SYSTEM: 'sistema'
};

// Rating types
const RATING_TYPES = {
  CLIENT_TO_COMPANY: 'cliente_a_empresa',
  COMPANY_TO_CLIENT: 'empresa_a_cliente'
};

// Branch status
const BRANCH_STATUS = {
  ACTIVE: 'activa',
  INACTIVE: 'inactiva',
  TEMPORARY: 'temporal'
};

// Error codes
const ERROR_CODES = {
  VALIDATION_ERROR: 'VALIDATION_ERROR',
  AUTHENTICATION_ERROR: 'AUTHENTICATION_ERROR',
  AUTHORIZATION_ERROR: 'AUTHORIZATION_ERROR',
  NOT_FOUND: 'NOT_FOUND',
  DUPLICATE_ENTRY: 'DUPLICATE_ENTRY',
  DATABASE_ERROR: 'DATABASE_ERROR',
  INTERNAL_ERROR: 'INTERNAL_ERROR',
  INVALID_COUPON: 'INVALID_COUPON',
  SERVICE_UNAVAILABLE: 'SERVICE_UNAVAILABLE'
};

// HTTP Status codes
const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  UNPROCESSABLE_ENTITY: 422,
  TOO_MANY_REQUESTS: 429,
  INTERNAL_SERVER_ERROR: 500
};

// Pagination defaults
const PAGINATION = {
  DEFAULT_PAGE: 1,
  DEFAULT_LIMIT: 20,
  MAX_LIMIT: 100
};

// Rating constraints
const RATING = {
  MIN: 1,
  MAX: 5
};

module.exports = {
  USER_TYPES,
  USER_STATUS,
  SERVICE_STATUS,
  CONTRACT_STATUS,
  PAYMENT_STATUS,
  PAYMENT_METHODS,
  COUPON_TYPES,
  COUPON_APPLICABILITY,
  CONVERSATION_STATUS,
  MESSAGE_TYPES,
  NOTIFICATION_TYPES,
  RATING_TYPES,
  BRANCH_STATUS,
  ERROR_CODES,
  HTTP_STATUS,
  PAGINATION,
  RATING
};
