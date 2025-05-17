import 'package:beauty_center_frontend/api/tool_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/tool_dto.dart';
import '../utils/Strings.dart';

part 'tool_provider.g.dart';


class ToolProviderData {
  final List<ToolDto> tools;

  ToolProviderData({List<ToolDto>? tools}) : tools = tools ?? [];

  ToolProviderData copyWith({List<ToolDto>? tools}) {
    return ToolProviderData(tools: tools ?? this.tools);
  }
}


@riverpod
class Tool extends _$Tool {
  final ToolService _toolService = ToolService();

  @override
  ToolProviderData build(){
    ref.keepAlive();
    return ToolProviderData();
  }


  Future<String> getAllTools() async {
    final response = await _toolService.getAllTools();

    if(response == null) return Strings.connection_error;
    if(response.statusCode == 200) {
      state = state.copyWith(
        tools: (response.data as List).map((json) => ToolDto.fromJson(json: json)).toList()
      );
      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }


  Future<MapEntry<bool, String>> createTool({required String name, required int availability}) async {
    final response = await _toolService.createTool(name: name, availability: availability);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 201) {
      List<ToolDto> newList = state.tools;
      newList.add(ToolDto.fromJson(json: response.data));
      state = state.copyWith(tools: newList);

      return MapEntry(true, Strings.tool_created_correctly);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> updateTool({required String id, required String name, required int availability}) async {
    final response = await _toolService.updateTool(id: id, name: name, availability: availability);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204) {
      List<ToolDto> newTools = state.tools;
      newTools = newTools.map((tool) {
        if(tool.id == id) {
          return ToolDto(id: id, name: name, availability: availability);
        }
        return tool;
      }).toList();
      state = state.copyWith(tools: newTools);

      return MapEntry(true, Strings.tool_updated_correctly);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> deleteTool({required String id}) async {
    final response = await _toolService.deleteTool(id: id);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204) {
      List<ToolDto> newTools = state.tools;
      newTools.removeWhere((tool) => tool.id == id);
      state = state.copyWith(tools: newTools);
      // todo rimuovere il tool dai service che lo hanno

      return MapEntry(true, Strings.tool_deleted_correctly);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }
}