import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:servicios_app/config/theme.dart';
import 'package:servicios_app/core/providers/notificacion_provider.dart';
import 'package:servicios_app/core/models/notificacion.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar notificaciones al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificacionProvider>(context, listen: false).loadNotificaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Marcar todas como leídas',
            onPressed: () {
              Provider.of<NotificacionProvider>(context, listen: false).markAllAsRead();
            },
          ),
        ],
      ),
      body: Consumer<NotificacionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.error}'),
                  ElevatedButton(
                    onPressed: () => provider.loadNotificaciones(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (provider.notificaciones.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No tienes notificaciones', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadNotificaciones(),
            child: ListView.builder(
              itemCount: provider.notificaciones.length,
              itemBuilder: (context, index) {
                final notificacion = provider.notificaciones[index];
                return _NotificationItem(notificacion: notificacion);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final Notificacion notificacion;

  const _NotificationItem({required this.notificacion});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificacionProvider>(context, listen: false);
    
    return Dismissible(
      key: Key(notificacion.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        provider.deleteNotificacion(notificacion.id);
      },
      child: Container(
        color: notificacion.leida ? null : AppTheme.primaryColor.withOpacity(0.05),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getIconColor(notificacion.tipo).withOpacity(0.1),
            child: Icon(_getIcon(notificacion.tipo), color: _getIconColor(notificacion.tipo)),
          ),
          title: Text(
            notificacion.titulo,
            style: TextStyle(
              fontWeight: notificacion.leida ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notificacion.mensaje),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(notificacion.fechaCreacion),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          onTap: () {
            provider.toggleRead(notificacion.id);
            // Aquí se podría navegar al detalle si hay enlace/referencia
          },
        ),
      ),
    );
  }

  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'contratacion':
        return Icons.assignment;
      case 'mensaje':
        return Icons.message;
      case 'calificacion':
        return Icons.star;
      case 'sistema':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String tipo) {
    switch (tipo) {
      case 'contratacion':
        return Colors.blue;
      case 'mensaje':
        return Colors.green;
      case 'calificacion':
        return Colors.amber;
      case 'sistema':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
