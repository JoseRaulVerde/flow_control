import 'package:flow_control/hooks/use_products_actions.dart';
import 'package:flow_control/models/work_component.dart';
import 'package:flow_control/repositories/components_services.dart';
import 'package:flow_control/routes.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flow_control/widgets/loading_check.dart';
import 'package:flow_control/widgets/message_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WorkList extends StatefulWidget {
  const WorkList({super.key});

  @override
  State<WorkList> createState() => _WorkListState();
}

class _WorkListState extends State<WorkList> {
  List<WorkComponent> _components = [];
  List<String> _productPhases = [];
  String _errorMessage = '';
  bool _isLoading = false;
  int? selectedIndex;
  WorkComponent? selectedComponent;
  int? selectedPhaseIndex;
  String? selectedPhase;
  final log = Logger();

  // Llamada a la API para obtención de componentes
  @override
  void initState() {
    super.initState();
    _getComponents();
    _getProductPhases();
  }

  void _getComponents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<WorkComponent> response =
          await ComponentsServices().getComponents();

      setState(() {
        _components = response;
        _errorMessage =
            response.isNotEmpty ? '' : 'No se encontraron componentes.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los componentes: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getProductPhases() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<String> response =
          await ComponentsServices().getProductPhases();

      setState(() {
        _productPhases = response;
        _errorMessage =
            response.isNotEmpty ? '' : 'No se encontraron componentes.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los componentes: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveSelectedComponent(selectedComponent) {
    final componentActions = useProductsActions(context);
    componentActions.addWorkComponent(selectedComponent);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Seleccionar trabajo",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Text(
                        "Componentes",
                        style: FormStyles.getTextStyleTitle(
                          font: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    _isLoading
                        ? LoadingCheck(
                          message: "Espere un momento",
                          icon: Icon(Icons.search_sharp),
                          loading: _isLoading,
                        )
                        : _components.isNotEmpty
                        ? _componentsList(_components)
                        : MessageCard(
                          message:
                              _errorMessage.isEmpty
                                  ? "No hay componentes disponibles."
                                  : _errorMessage,
                          iconMessage: Icon(Icons.error_outline),
                          isError: true,
                        ),
                    // Fases del producto
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20,
                      ),
                      child: Text(
                        "Fases del producto",
                        style: FormStyles.getTextStyleTitle(
                          font: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    _isLoading
                        ? LoadingCheck(
                          message: "Espere un momento",
                          icon: Icon(Icons.search_sharp),
                          loading: _isLoading,
                        )
                        : _productPhases.isNotEmpty
                        ? _productPhasesList(_productPhases)
                        : MessageCard(
                          message:
                              _errorMessage.isEmpty
                                  ? "No hay componentes disponibles."
                                  : _errorMessage,
                          iconMessage: Icon(Icons.error_outline),
                          isError: true,
                        ),
                  ],
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    selectedComponent != null || selectedPhase != null
                        ? () {
                          final WorkComponent selectedWork =
                              selectedComponent ??
                              WorkComponent(
                                code: '',
                                title: selectedPhase!,
                                subtitle: '',
                                category: '',
                              );
                          _saveSelectedComponent(selectedWork);
                          Future.delayed(Duration(milliseconds: 200), () {
                            // Pequeña espera para asegurar que se guarde

                            if (!mounted) return;
                            Navigator.pushNamed(
                              context,
                              AppRoutes.home,
                              arguments: 1, // 👈 índice de WorkScreen
                            );
                          });
                        }
                        : null,
                child: Text(
                  'Seleccionar trabajo',
                  style: FormStyles.getTextStyleTitle(
                    font: 18,
                    color:
                        selectedIndex != null || selectedPhaseIndex != null
                            ? Colors.white
                            : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _componentsList(List<WorkComponent> components) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: components.length,
      itemBuilder: (context, index) {
        final component = components[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: ListTile(
              minLeadingWidth: 10,
              dense: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: CircleAvatar(
                maxRadius: 15,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  component.code,
                  style: FormStyles.getTextStyle(font: 8, color: Colors.black),
                ),
              ),
              title: Text(
                component.title,
                style: FormStyles.getTextStyleTitle(
                  font: 14,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                component.subtitle,
                style: FormStyles.getTextStyleSubitle(
                  font: 10,
                  color: Colors.blueGrey,
                ),
              ),
              trailing:
                  selectedIndex == index
                      ? Icon(Icons.check, color: Colors.blue)
                      : null,
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  selectedComponent = component;
                  selectedPhaseIndex = null;
                  selectedPhase = null;
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _productPhasesList(List<String> phases) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: phases.length,
      itemBuilder: (context, index) {
        final phase = phases[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: ListTile(
              dense: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: CircleAvatar(
                maxRadius: 15,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.clean_hands, size: 12, color: Colors.white),
              ),
              title: Text(
                phase,
                style: FormStyles.getTextStyleTitle(
                  font: 12,
                  color: Colors.black,
                ),
              ),
              trailing:
                  selectedPhaseIndex == index
                      ? Icon(Icons.check, color: Colors.blue)
                      : null,
              onTap: () {
                setState(() {
                  selectedPhaseIndex = index;
                  selectedPhase = phase;
                  selectedComponent = null;
                  selectedIndex = null;
                });
              },
            ),
          ),
        );
      },
    );
  }
}
