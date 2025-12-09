import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_app/core/models/servicio.dart';
import 'package:servicios_app/core/services/chatbot_service.dart';
import 'package:servicios_app/features/servicio/screens/servicio_detail_screen.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatbotService _chatbotService = ChatbotService();
  
  final List<Map<String, dynamic>> _messages = []; // {role: 'user'|'assistant', content: String, services: List<Servicio>?}
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add initial greeting
    _messages.add({
      'role': 'assistant',
      'content': '¡Hola! Soy tu asistente virtual. ¿Qué tipo de servicio estás buscando hoy?',
      'services': null,
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();
    _controller.clear();

    setState(() {
      _messages.add({
        'role': 'user',
        'content': userMessage,
        'services': null,
      });
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // Prepare history for API (only role and content)
      final history = _messages
          .where((m) => m['role'] != 'system') // Exclude system messages if any
          .map((m) => {
                'role': m['role'] as String,
                'content': m['content'] as String,
              })
          .toList();

      final response = await _chatbotService.sendMessage(userMessage, history);

      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': response['message'],
          'services': response['services'],
        });
        _isLoading = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add({
          'role': 'assistant',
          'content': 'Lo siento, tuve un problema al procesar tu mensaje. Por favor intenta de nuevo.',
          'services': null,
        });
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Virtual'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                final services = msg['services'] as List<Servicio>?;

                return Column(
                  crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Theme.of(context).primaryColor : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12).copyWith(
                          bottomRight: isUser ? Radius.zero : null,
                          bottomLeft: !isUser ? Radius.zero : null,
                        ),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      child: Text(
                        msg['content'],
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    if (services != null && services.isNotEmpty)
                      Container(
                        height: 180,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: services.length,
                          itemBuilder: (context, sIndex) {
                            final service = services[sIndex];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServicioDetailScreen(servicioId: service.id),
                                  ),
                                );
                              },
                              child: Container(
                                width: 160,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        child: service.imagenPrincipal != null
                                            ? Image.network(
                                                service.imagenPrincipal!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                                              )
                                            : Container(color: Colors.grey[300]),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service.nombre,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '\$${service.precio}',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
