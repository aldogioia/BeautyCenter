import 'package:beauty_center_frontend/provider/tool_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/summary_tool_dto.dart';
import '../model/tool_dto.dart';
import 'custom_chip.dart';

class CustomToolWrap extends ConsumerStatefulWidget {
  const CustomToolWrap({
    super.key,
    required this.onChipTap,
    required this.initialTools
  });

  final void Function(List<SummaryToolDto>) onChipTap;
  final List<SummaryToolDto> initialTools;

  @override
  ConsumerState<CustomToolWrap> createState() => _CustomToolWrapState();
}

class _CustomToolWrapState extends ConsumerState<CustomToolWrap> {
  List<SummaryToolDto> _selectedTools = [];


  void _onChipTap({required ToolDto toolDto}){
    setState(() {
      int index = _selectedTools.indexWhere((e) => e.id == toolDto.id);

      if(index == -1) {
        _selectedTools.add(SummaryToolDto(id: toolDto.id, name: toolDto.name));
      } else {
        _selectedTools.removeAt(index);
      }

      widget.onChipTap(_selectedTools);
    });
  }


  @override
  void initState() {
    _selectedTools = List.from(widget.initialTools);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final tools = ref.watch(toolProvider.select((state) => state.tools));

    return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: tools.map((tool) {
          return CustomChip(
            text: tool.name,
            onTap: () => _onChipTap(toolDto: tool),
            isSelected: _selectedTools.any((e) => e.id == tool.id),
          );
        }).toList()
    );
  }
}
