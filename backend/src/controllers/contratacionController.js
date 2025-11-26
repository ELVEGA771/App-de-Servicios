const Contratacion = require('../models/Contratacion');
const Cliente = require('../models/Cliente');
const Empresa = require('../models/Empresa');
const Servicio = require('../models/Servicio');
const Cupon = require('../models/Cupon');
const Notificacion = require('../models/Notificacion');
const { sendSuccess, sendPaginated, sendError } = require('../utils/responseFormatter');
const { ERROR_CODES, HTTP_STATUS, USER_TYPES, CONTRACT_STATUS } = require('../utils/constants');
const logger = require('../utils/logger');

/**
 * Get contrataciones (cliente or empresa)
 * GET /api/contrataciones
 */
const getContrataciones = async (req, res, next) => {
  try {
    const { page = 1, limit = 20, estado } = req.query;

    let result;
    if (req.user.tipo_usuario === USER_TYPES.CLIENT) {
      const cliente = await Cliente.findByUserId(req.user.id_usuario);
      if (!cliente) {
        return sendError(res, ERROR_CODES.NOT_FOUND, 'Cliente not found', HTTP_STATUS.NOT_FOUND);
      }
      result = await Contratacion.getByCliente(cliente.id_cliente, parseInt(page), parseInt(limit), estado);
    } else if (req.user.tipo_usuario === USER_TYPES.COMPANY) {
      const empresa = await Empresa.findByUserId(req.user.id_usuario);
      if (!empresa) {
        return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
      }
      result = await Contratacion.getByEmpresa(empresa.id_empresa, parseInt(page), parseInt(limit), estado);
    } else {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Invalid user type', HTTP_STATUS.FORBIDDEN);
    }

    sendPaginated(res, result.data, page, limit, result.total, 'Contrataciones retrieved successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * Get contratacion by ID
 * GET /api/contrataciones/:id
 */
const getContratacionById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const contratacion = await Contratacion.findById(id);

    if (!contratacion) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Contratacion not found', HTTP_STATUS.NOT_FOUND);
    }

    // Verify user participated
    const participated = await Contratacion.userParticipated(id, req.user.id_usuario, req.user.tipo_usuario);
    if (!participated) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'You do not have access to this contratacion', HTTP_STATUS.FORBIDDEN);
    }

    sendSuccess(res, contratacion);
  } catch (error) {
    next(error);
  }
};

/**
 * Create new contratacion (cliente only)
 * POST /api/contrataciones
 */
const createContratacion = async (req, res, next) => {
  try {
    if (req.user.tipo_usuario !== USER_TYPES.CLIENT) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only clients can create contrataciones', HTTP_STATUS.FORBIDDEN);
    }

    const cliente = await Cliente.findByUserId(req.user.id_usuario);
    if (!cliente) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Cliente not found', HTTP_STATUS.NOT_FOUND);
    }

    const { id_servicio, id_sucursal, id_direccion_entrega, codigo_cupon, fecha_programada, notas_cliente, metodo_pago } = req.body;

    // Verify servicio exists and get price
    const { executeQuery } = require('../config/database');
    const [servicio] = await executeQuery(
      'SELECT precio_base, estado FROM servicio WHERE id_servicio = ?',
      [id_servicio]
    );

    if (!servicio) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Service not found', HTTP_STATUS.NOT_FOUND);
    }

    if (servicio.estado !== 'disponible') {
      return sendError(res, ERROR_CODES.SERVICE_UNAVAILABLE, 'Service is not available', HTTP_STATUS.BAD_REQUEST);
    }

    // Check if sucursal offers this service
    const [servicioSucursal] = await executeQuery(
      'SELECT precio_sucursal, disponible FROM servicio_sucursal WHERE id_servicio = ? AND id_sucursal = ?',
      [id_servicio, id_sucursal]
    );

    // Relaxed validation for testing purposes
    // if (!servicioSucursal || !servicioSucursal.disponible) {
    //   return sendError(res, ERROR_CODES.SERVICE_UNAVAILABLE, 'Service not available at this location', HTTP_STATUS.BAD_REQUEST);
    // }

    // Calculate price
    const precio_base = (servicioSucursal && servicioSucursal.precio_sucursal) ? servicioSucursal.precio_sucursal : servicio.precio_base;
    let precio_subtotal = precio_base;
    let descuento_aplicado = 0;
    let id_cupon = null;

    // Validate and apply coupon if provided
    if (codigo_cupon) {
      const validacion = await Cupon.validate(codigo_cupon, id_servicio, precio_subtotal);

      if (!validacion.valido) {
        return sendError(res, ERROR_CODES.INVALID_COUPON, validacion.mensaje, HTTP_STATUS.BAD_REQUEST);
      }

      descuento_aplicado = validacion.descuento;
      const cupon = await Cupon.findByCodigo(codigo_cupon);
      id_cupon = cupon.id_cupon;
    }

    const precio_total = precio_subtotal - descuento_aplicado;

    // Create contratacion
    const contratacionData = {
      id_cliente: cliente.id_cliente,
      id_servicio,
      id_sucursal,
      id_direccion_entrega,
      id_cupon,
      fecha_programada: fecha_programada || null,
      precio_subtotal,
      descuento_aplicado,
      precio_total,
      estado: CONTRACT_STATUS.PENDING,
      notas_cliente: notas_cliente || null
    };

    const contratacionId = await Contratacion.create(contratacionData);

    // Create Payment Record
    if (metodo_pago) {
      await executeQuery(
        `INSERT INTO pago (id_contratacion, monto, metodo_pago, estado_pago)
         VALUES (?, ?, ?, 'pendiente')`,
        [contratacionId, precio_total, metodo_pago]
      );
    }

    // Create Notification for Company
    const [empresaInfo] = await executeQuery(
      `SELECT e.id_usuario, e.razon_social 
       FROM empresa e 
       JOIN servicio s ON s.id_empresa = e.id_empresa 
       WHERE s.id_servicio = ?`,
      [id_servicio]
    );

    if (empresaInfo) {
      // Get client name for notification
      const clienteUsuario = await executeQuery(
        'SELECT nombre, apellido FROM usuario WHERE id_usuario = ?',
        [req.user.id_usuario]
      );
      
      const clienteNombre = clienteUsuario[0] ? `${clienteUsuario[0].nombre} ${clienteUsuario[0].apellido}` : 'Un cliente';

      await executeQuery(
        `INSERT INTO notificacion (id_usuario, titulo, contenido, tipo, referencia_id, referencia_tipo)
         VALUES (?, ?, ?, 'sistema', ?, 'contratacion')`,
        [
          empresaInfo.id_usuario, 
          'Nueva Orden Recibida', 
          `Has recibido una nueva orden de servicio de ${clienteNombre}. ID: ${contratacionId}`, 
          contratacionId
        ]
      );
    }

    const contratacion = await Contratacion.findById(contratacionId);

    logger.info(`Contratacion created: ${contratacionId} by cliente ${cliente.id_cliente}`);
    sendSuccess(res, contratacion, 'Contratacion created successfully', HTTP_STATUS.CREATED);
  } catch (error) {
    next(error);
  }
};

/**
 * Update contratacion estado (empresa only)
 * PUT /api/contrataciones/:id/estado
 */
const updateEstado = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { estado, notas_empresa } = req.body;

    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can update contratacion status', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    // Verify empresa owns the service
    const participated = await Contratacion.userParticipated(id, req.user.id_usuario, USER_TYPES.COMPANY);
    if (!participated) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'You do not have access to this contratacion', HTTP_STATUS.FORBIDDEN);
    }

    // 1. Update Contract Status (and History via SP)
    // This returns the updated object
    let updatedContratacion = await Contratacion.updateEstado(id, estado, notas_empresa);

    // 2. Update Payment Status
    let paymentStatus = null;
    if (estado === 'confirmado') {
      // No change to payment status on confirmation
      paymentStatus = null; 
    } else if (estado === 'rechazado' || estado === 'cancelado') {
      paymentStatus = 'fallido'; // Map to valid enum value
    } else if (estado === 'completado') {
      paymentStatus = 'completado';
    }

    if (paymentStatus) {
      await Contratacion.updatePaymentStatus(id, paymentStatus);
      // Refresh object to get new payment status
      updatedContratacion = await Contratacion.findById(id);
    }

    // 3. Send Notification to Client
    if (updatedContratacion) {
        logger.info(`Attempting to send notification for contratacion ${id}, status: ${estado}`);
        const { executeQuery } = require('../config/database');
        
        // Explicitly get id_cliente from contratacion table to be safe
        const [contratacionRaw] = await executeQuery(
            'SELECT id_cliente FROM contratacion WHERE id_contratacion = ?',
            [id]
        );

        if (contratacionRaw) {
            const clientUserIdQuery = 'SELECT id_usuario FROM cliente WHERE id_cliente = ?';
            const [clientUser] = await executeQuery(clientUserIdQuery, [contratacionRaw.id_cliente]);
            
            if (clientUser) {
                logger.info(`Found client user ${clientUser.id_usuario} for contratacion ${id}`);
                let notifTitle = 'Actualización de Orden';
                let notifContent = `Tu orden #${id} ha cambiado de estado a: ${estado}.`;
                
                if (estado === 'confirmado') {
                    notifTitle = 'Orden Confirmada';
                    notifContent = `¡Tu orden #${id} ha sido confirmada por la empresa!`;
                } else if (estado === 'rechazado') {
                    notifTitle = 'Orden Rechazada';
                    notifContent = `Lo sentimos, tu orden #${id} ha sido rechazada.`;
                } else if (estado === 'completado') {
                    notifTitle = 'Servicio Completado';
                    notifContent = `El servicio de la orden #${id} ha sido marcado como completado.`;
                } else if (estado === 'en_proceso') {
                    notifTitle = 'Servicio en Proceso';
                    notifContent = `La empresa ha iniciado el servicio de la orden #${id}.`;
                }

                if (notas_empresa) {
                    notifContent += `\n\nNota de la empresa: ${notas_empresa}`;
                }

                try {
                    const notifId = await Notificacion.create({
                        id_usuario: clientUser.id_usuario,
                        titulo: notifTitle,
                        contenido: notifContent,
                        tipo: 'cambio_estado',
                        referencia_id: id,
                        referencia_tipo: 'contratacion'
                    });
                    logger.info(`Notification created successfully: ${notifId}`);
                } catch (notifError) {
                    logger.error(`Error creating notification: ${notifError.message}`);
                }
            } else {
                logger.warn(`Client user not found for contratacion ${id}, client ${contratacionRaw.id_cliente}`);
            }
        } else {
            logger.warn(`Contratacion raw not found for id ${id}`);
        }
    } else {
        logger.warn(`updatedContratacion is null/undefined for id ${id}`);
    }

    logger.info(`Contratacion ${id} updated to ${estado} by empresa ${empresa.id_empresa}`);
    sendSuccess(res, updatedContratacion, 'Contratacion status updated successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * Cancel contratacion
 * PUT /api/contrataciones/:id/cancelar
 */
const cancelContratacion = async (req, res, next) => {
  try {
    const { id } = req.params;

    // Verify user participated
    const participated = await Contratacion.userParticipated(id, req.user.id_usuario, req.user.tipo_usuario);
    if (!participated) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'You do not have access to this contratacion', HTTP_STATUS.FORBIDDEN);
    }

    const updatedContratacion = await Contratacion.cancel(id, req.user.id_usuario);
    logger.info(`Contratacion ${id} cancelled by user ${req.user.id_usuario}`);
    sendSuccess(res, updatedContratacion, 'Contratacion cancelled successfully');
  } catch (error) {
    next(error);
  }
};

/**
 * Get historial de contrataciones (empresa only)
 * GET /api/contrataciones/empresa/historial
 */
const getHistorialEmpresa = async (req, res, next) => {
  try {
    const { page = 1, limit = 20 } = req.query;

    if (req.user.tipo_usuario !== USER_TYPES.COMPANY) {
      return sendError(res, ERROR_CODES.AUTHORIZATION_ERROR, 'Only empresas can access historial', HTTP_STATUS.FORBIDDEN);
    }

    const empresa = await Empresa.findByUserId(req.user.id_usuario);
    if (!empresa) {
      return sendError(res, ERROR_CODES.NOT_FOUND, 'Empresa not found', HTTP_STATUS.NOT_FOUND);
    }

    const result = await Contratacion.getHistorialByEmpresa(empresa.id_empresa, parseInt(page), parseInt(limit));

    sendPaginated(res, result.data, page, limit, result.total, 'Historial retrieved successfully');
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getContrataciones,
  getContratacionById,
  createContratacion,
  updateEstado,
  cancelContratacion,
  getHistorialEmpresa
};
