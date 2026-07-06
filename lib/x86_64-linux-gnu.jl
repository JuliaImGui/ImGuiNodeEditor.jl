module lib

using CEnum: CEnum, @cenum

using cimnodes_editor_jll: libcimnodes_editor

using CImGui: ImVec2, ImVec4, ImVector_float, ImDrawList, ImGuiMouseButton


mutable struct NodeId end

mutable struct LinkId end

mutable struct PinId end

mutable struct EditorContext end

@cenum PinKind::UInt32 begin
    Input = 0
    Output = 1
end

@cenum FlowDirection::UInt32 begin
    Forward = 0
    Backward = 1
end

@cenum CanvasSizeMode::UInt32 begin
    FitVerticalView = 0
    FitHorizontalView = 1
    CenterOnly = 2
end

@cenum SaveReasonFlags::UInt32 begin
    None = 0
    Navigation = 1
    Position = 2
    Size = 4
    Selection = 8
    AddNode = 16
    RemoveNode = 32
    User = 64
end

# typedef bool ( * ConfigSaveSettings ) ( const char * data , size_t size , SaveReasonFlags reason , void * userPointer )
const ConfigSaveSettings = Ptr{Cvoid}

# typedef size_t ( * ConfigLoadSettings ) ( char * data , void * userPointer )
const ConfigLoadSettings = Ptr{Cvoid}

# typedef bool ( * ConfigSaveNodeSettings ) ( NodeId nodeId , const char * data , size_t size , SaveReasonFlags reason , void * userPointer )
const ConfigSaveNodeSettings = Ptr{Cvoid}

# typedef size_t ( * ConfigLoadNodeSettings ) ( NodeId nodeId , char * data , void * userPointer )
const ConfigLoadNodeSettings = Ptr{Cvoid}

# typedef void ( * ConfigSession ) ( void * userPointer )
const ConfigSession = Ptr{Cvoid}

const CanvasSizeModeAlias = CanvasSizeMode

struct Config
    SettingsFile::Ptr{Cchar}
    BeginSaveSession::ConfigSession
    EndSaveSession::ConfigSession
    SaveSettings::ConfigSaveSettings
    LoadSettings::ConfigLoadSettings
    SaveNodeSettings::ConfigSaveNodeSettings
    LoadNodeSettings::ConfigLoadNodeSettings
    UserPointer::Ptr{Cvoid}
    CustomZoomLevels::ImVector_float
    CanvasSizeMode::CanvasSizeModeAlias
    DragButtonIndex::Cint
    SelectButtonIndex::Cint
    NavigateButtonIndex::Cint
    ContextMenuButtonIndex::Cint
    EnableSmoothZoom::Bool
    SmoothZoomPower::Cfloat
end
function Base.getproperty(x::Ptr{Config}, f::Symbol)
    f === :SettingsFile && return Ptr{Ptr{Cchar}}(x + 0)
    f === :BeginSaveSession && return Ptr{ConfigSession}(x + 8)
    f === :EndSaveSession && return Ptr{ConfigSession}(x + 16)
    f === :SaveSettings && return Ptr{ConfigSaveSettings}(x + 24)
    f === :LoadSettings && return Ptr{ConfigLoadSettings}(x + 32)
    f === :SaveNodeSettings && return Ptr{ConfigSaveNodeSettings}(x + 40)
    f === :LoadNodeSettings && return Ptr{ConfigLoadNodeSettings}(x + 48)
    f === :UserPointer && return Ptr{Ptr{Cvoid}}(x + 56)
    f === :CustomZoomLevels && return Ptr{ImVector_float}(x + 64)
    f === :CanvasSizeMode && return Ptr{CanvasSizeModeAlias}(x + 80)
    f === :DragButtonIndex && return Ptr{Cint}(x + 84)
    f === :SelectButtonIndex && return Ptr{Cint}(x + 88)
    f === :NavigateButtonIndex && return Ptr{Cint}(x + 92)
    f === :ContextMenuButtonIndex && return Ptr{Cint}(x + 96)
    f === :EnableSmoothZoom && return Ptr{Bool}(x + 100)
    f === :SmoothZoomPower && return Ptr{Cfloat}(x + 104)
    return getfield(x, f)
end

function Base.setproperty!(x::Ptr{Config}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end


@cenum StyleColor::UInt32 begin
    StyleColor_Bg = 0
    StyleColor_Grid = 1
    StyleColor_NodeBg = 2
    StyleColor_NodeBorder = 3
    StyleColor_HovNodeBorder = 4
    StyleColor_SelNodeBorder = 5
    StyleColor_NodeSelRect = 6
    StyleColor_NodeSelRectBorder = 7
    StyleColor_HovLinkBorder = 8
    StyleColor_SelLinkBorder = 9
    StyleColor_HighlightLinkBorder = 10
    StyleColor_LinkSelRect = 11
    StyleColor_LinkSelRectBorder = 12
    StyleColor_PinRect = 13
    StyleColor_PinRectBorder = 14
    StyleColor_Flow = 15
    StyleColor_FlowMarker = 16
    StyleColor_GroupBg = 17
    StyleColor_GroupBorder = 18
    StyleColor_Count = 19
end

@cenum StyleVar::UInt32 begin
    StyleVar_NodePadding = 0
    StyleVar_NodeRounding = 1
    StyleVar_NodeBorderWidth = 2
    StyleVar_HoveredNodeBorderWidth = 3
    StyleVar_SelectedNodeBorderWidth = 4
    StyleVar_PinRounding = 5
    StyleVar_PinBorderWidth = 6
    StyleVar_LinkStrength = 7
    StyleVar_SourceDirection = 8
    StyleVar_TargetDirection = 9
    StyleVar_ScrollDuration = 10
    StyleVar_FlowMarkerDistance = 11
    StyleVar_FlowSpeed = 12
    StyleVar_FlowDuration = 13
    StyleVar_PivotAlignment = 14
    StyleVar_PivotSize = 15
    StyleVar_PivotScale = 16
    StyleVar_PinCorners = 17
    StyleVar_PinRadius = 18
    StyleVar_PinArrowSize = 19
    StyleVar_PinArrowWidth = 20
    StyleVar_GroupRounding = 21
    StyleVar_GroupBorderWidth = 22
    StyleVar_HighlightConnectedLinks = 23
    StyleVar_SnapLinkToPinDir = 24
    StyleVar_HoveredNodeBorderOffset = 25
    StyleVar_SelectedNodeBorderOffset = 26
    StyleVar_Count = 27
end

struct cimnodes_editor_Style
    NodePadding::ImVec4
    NodeRounding::Cfloat
    NodeBorderWidth::Cfloat
    HoveredNodeBorderWidth::Cfloat
    HoverNodeBorderOffset::Cfloat
    SelectedNodeBorderWidth::Cfloat
    SelectedNodeBorderOffset::Cfloat
    PinRounding::Cfloat
    PinBorderWidth::Cfloat
    LinkStrength::Cfloat
    SourceDirection::ImVec2
    TargetDirection::ImVec2
    ScrollDuration::Cfloat
    FlowMarkerDistance::Cfloat
    FlowSpeed::Cfloat
    FlowDuration::Cfloat
    PivotAlignment::ImVec2
    PivotSize::ImVec2
    PivotScale::ImVec2
    PinCorners::Cfloat
    PinRadius::Cfloat
    PinArrowSize::Cfloat
    PinArrowWidth::Cfloat
    GroupRounding::Cfloat
    GroupBorderWidth::Cfloat
    HighlightConnectedLinks::Cfloat
    SnapLinkToPinDir::Cfloat
    Colors::NTuple{19, ImVec4}
end
function Base.getproperty(x::Ptr{cimnodes_editor_Style}, f::Symbol)
    f === :NodePadding && return Ptr{ImVec4}(x + 0)
    f === :NodeRounding && return Ptr{Cfloat}(x + 16)
    f === :NodeBorderWidth && return Ptr{Cfloat}(x + 20)
    f === :HoveredNodeBorderWidth && return Ptr{Cfloat}(x + 24)
    f === :HoverNodeBorderOffset && return Ptr{Cfloat}(x + 28)
    f === :SelectedNodeBorderWidth && return Ptr{Cfloat}(x + 32)
    f === :SelectedNodeBorderOffset && return Ptr{Cfloat}(x + 36)
    f === :PinRounding && return Ptr{Cfloat}(x + 40)
    f === :PinBorderWidth && return Ptr{Cfloat}(x + 44)
    f === :LinkStrength && return Ptr{Cfloat}(x + 48)
    f === :SourceDirection && return Ptr{ImVec2}(x + 52)
    f === :TargetDirection && return Ptr{ImVec2}(x + 60)
    f === :ScrollDuration && return Ptr{Cfloat}(x + 68)
    f === :FlowMarkerDistance && return Ptr{Cfloat}(x + 72)
    f === :FlowSpeed && return Ptr{Cfloat}(x + 76)
    f === :FlowDuration && return Ptr{Cfloat}(x + 80)
    f === :PivotAlignment && return Ptr{ImVec2}(x + 84)
    f === :PivotSize && return Ptr{ImVec2}(x + 92)
    f === :PivotScale && return Ptr{ImVec2}(x + 100)
    f === :PinCorners && return Ptr{Cfloat}(x + 108)
    f === :PinRadius && return Ptr{Cfloat}(x + 112)
    f === :PinArrowSize && return Ptr{Cfloat}(x + 116)
    f === :PinArrowWidth && return Ptr{Cfloat}(x + 120)
    f === :GroupRounding && return Ptr{Cfloat}(x + 124)
    f === :GroupBorderWidth && return Ptr{Cfloat}(x + 128)
    f === :HighlightConnectedLinks && return Ptr{Cfloat}(x + 132)
    f === :SnapLinkToPinDir && return Ptr{Cfloat}(x + 136)
    f === :Colors && return Ptr{NTuple{19, ImVec4}}(x + 140)
    return getfield(x, f)
end

function Base.setproperty!(x::Ptr{cimnodes_editor_Style}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end


mutable struct SafeType end

mutable struct SafePointerType end

function ax_NodeEditor_Config_Config_Config()
    ccall((:ax_NodeEditor_Config_Config_Config, libcimnodes_editor), Ptr{Config}, ())
end

function Config_destroy(self)
    ccall((:Config_destroy, libcimnodes_editor), Cvoid, (Ptr{Config},), self)
end

function ax_NodeEditor_SetCurrentEditor(ctx)
    ccall((:ax_NodeEditor_SetCurrentEditor, libcimnodes_editor), Cvoid, (Ptr{EditorContext},), ctx)
end

function ax_NodeEditor_GetCurrentEditor()
    ccall((:ax_NodeEditor_GetCurrentEditor, libcimnodes_editor), Ptr{EditorContext}, ())
end

function ax_NodeEditor_CreateEditor(config)
    ccall((:ax_NodeEditor_CreateEditor, libcimnodes_editor), Ptr{EditorContext}, (Ptr{Config},), config)
end

function ax_NodeEditor_DestroyEditor(ctx)
    ccall((:ax_NodeEditor_DestroyEditor, libcimnodes_editor), Cvoid, (Ptr{EditorContext},), ctx)
end

function ax_NodeEditor_GetConfig(ctx)
    ccall((:ax_NodeEditor_GetConfig, libcimnodes_editor), Ptr{Config}, (Ptr{EditorContext},), ctx)
end

function ax_NodeEditor_GetStyle()
    ccall((:ax_NodeEditor_GetStyle, libcimnodes_editor), Ptr{cimnodes_editor_Style}, ())
end

function ax_NodeEditor_GetStyleColorName(colorIndex)
    ccall((:ax_NodeEditor_GetStyleColorName, libcimnodes_editor), Ptr{Cchar}, (StyleColor,), colorIndex)
end

function ax_NodeEditor_PushStyleColor(colorIndex, color)
    ccall((:ax_NodeEditor_PushStyleColor, libcimnodes_editor), Cvoid, (StyleColor, ImVec4), colorIndex, color)
end

function ax_NodeEditor_PopStyleColor(count)
    ccall((:ax_NodeEditor_PopStyleColor, libcimnodes_editor), Cvoid, (Cint,), count)
end

function ax_NodeEditor_PushStyleVar_Float(varIndex, value)
    ccall((:ax_NodeEditor_PushStyleVar_Float, libcimnodes_editor), Cvoid, (StyleVar, Cfloat), varIndex, value)
end

function ax_NodeEditor_PushStyleVar_Vec2(varIndex, value)
    ccall((:ax_NodeEditor_PushStyleVar_Vec2, libcimnodes_editor), Cvoid, (StyleVar, ImVec2), varIndex, value)
end

function ax_NodeEditor_PushStyleVar_Vec4(varIndex, value)
    ccall((:ax_NodeEditor_PushStyleVar_Vec4, libcimnodes_editor), Cvoid, (StyleVar, ImVec4), varIndex, value)
end

function ax_NodeEditor_PopStyleVar(count)
    ccall((:ax_NodeEditor_PopStyleVar, libcimnodes_editor), Cvoid, (Cint,), count)
end

function ax_NodeEditor_Begin(id, size)
    ccall((:ax_NodeEditor_Begin, libcimnodes_editor), Cvoid, (Ptr{Cchar}, ImVec2), id, size)
end

function ax_NodeEditor_End()
    ccall((:ax_NodeEditor_End, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_BeginNode(id)
    ccall((:ax_NodeEditor_BeginNode, libcimnodes_editor), Cvoid, (Ptr{NodeId},), id)
end

function ax_NodeEditor_BeginPin(id, kind)
    ccall((:ax_NodeEditor_BeginPin, libcimnodes_editor), Cvoid, (Ptr{PinId}, PinKind), id, kind)
end

function ax_NodeEditor_PinRect(a, b)
    ccall((:ax_NodeEditor_PinRect, libcimnodes_editor), Cvoid, (ImVec2, ImVec2), a, b)
end

function ax_NodeEditor_PinPivotRect(a, b)
    ccall((:ax_NodeEditor_PinPivotRect, libcimnodes_editor), Cvoid, (ImVec2, ImVec2), a, b)
end

function ax_NodeEditor_PinPivotSize(size)
    ccall((:ax_NodeEditor_PinPivotSize, libcimnodes_editor), Cvoid, (ImVec2,), size)
end

function ax_NodeEditor_PinPivotScale(scale)
    ccall((:ax_NodeEditor_PinPivotScale, libcimnodes_editor), Cvoid, (ImVec2,), scale)
end

function ax_NodeEditor_PinPivotAlignment(alignment)
    ccall((:ax_NodeEditor_PinPivotAlignment, libcimnodes_editor), Cvoid, (ImVec2,), alignment)
end

function ax_NodeEditor_EndPin()
    ccall((:ax_NodeEditor_EndPin, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_Group(size)
    ccall((:ax_NodeEditor_Group, libcimnodes_editor), Cvoid, (ImVec2,), size)
end

function ax_NodeEditor_EndNode()
    ccall((:ax_NodeEditor_EndNode, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_BeginGroupHint(nodeId)
    ccall((:ax_NodeEditor_BeginGroupHint, libcimnodes_editor), Bool, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_GetGroupMin()
    ccall((:ax_NodeEditor_GetGroupMin, libcimnodes_editor), ImVec2, ())
end

function ax_NodeEditor_GetGroupMax()
    ccall((:ax_NodeEditor_GetGroupMax, libcimnodes_editor), ImVec2, ())
end

function ax_NodeEditor_GetHintForegroundDrawList()
    ccall((:ax_NodeEditor_GetHintForegroundDrawList, libcimnodes_editor), Ptr{ImDrawList}, ())
end

function ax_NodeEditor_GetHintBackgroundDrawList()
    ccall((:ax_NodeEditor_GetHintBackgroundDrawList, libcimnodes_editor), Ptr{ImDrawList}, ())
end

function ax_NodeEditor_EndGroupHint()
    ccall((:ax_NodeEditor_EndGroupHint, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_GetNodeBackgroundDrawList(nodeId)
    ccall((:ax_NodeEditor_GetNodeBackgroundDrawList, libcimnodes_editor), Ptr{ImDrawList}, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_Link(id, startPinId, endPinId, color, thickness)
    ccall((:ax_NodeEditor_Link, libcimnodes_editor), Bool, (Ptr{LinkId}, Ptr{PinId}, Ptr{PinId}, ImVec4, Cfloat), id, startPinId, endPinId, color, thickness)
end

function ax_NodeEditor_Flow(linkId, direction)
    ccall((:ax_NodeEditor_Flow, libcimnodes_editor), Cvoid, (Ptr{LinkId}, FlowDirection), linkId, direction)
end

function ax_NodeEditor_BeginCreate(color, thickness)
    ccall((:ax_NodeEditor_BeginCreate, libcimnodes_editor), Bool, (ImVec4, Cfloat), color, thickness)
end

function ax_NodeEditor_QueryNewLink_Nil(startId, endId)
    ccall((:ax_NodeEditor_QueryNewLink_Nil, libcimnodes_editor), Bool, (Ptr{PinId}, Ptr{PinId}), startId, endId)
end

function ax_NodeEditor_QueryNewLink_Vec4(startId, endId, color, thickness)
    ccall((:ax_NodeEditor_QueryNewLink_Vec4, libcimnodes_editor), Bool, (Ptr{PinId}, Ptr{PinId}, ImVec4, Cfloat), startId, endId, color, thickness)
end

function ax_NodeEditor_QueryNewNode_Nil(pinId)
    ccall((:ax_NodeEditor_QueryNewNode_Nil, libcimnodes_editor), Bool, (Ptr{PinId},), pinId)
end

function ax_NodeEditor_QueryNewNode_Vec4(pinId, color, thickness)
    ccall((:ax_NodeEditor_QueryNewNode_Vec4, libcimnodes_editor), Bool, (Ptr{PinId}, ImVec4, Cfloat), pinId, color, thickness)
end

function ax_NodeEditor_AcceptNewItem_Nil()
    ccall((:ax_NodeEditor_AcceptNewItem_Nil, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_AcceptNewItem_Vec4(color, thickness)
    ccall((:ax_NodeEditor_AcceptNewItem_Vec4, libcimnodes_editor), Bool, (ImVec4, Cfloat), color, thickness)
end

function ax_NodeEditor_RejectNewItem_Nil()
    ccall((:ax_NodeEditor_RejectNewItem_Nil, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_RejectNewItem_Vec4(color, thickness)
    ccall((:ax_NodeEditor_RejectNewItem_Vec4, libcimnodes_editor), Cvoid, (ImVec4, Cfloat), color, thickness)
end

function ax_NodeEditor_EndCreate()
    ccall((:ax_NodeEditor_EndCreate, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_BeginDelete()
    ccall((:ax_NodeEditor_BeginDelete, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_QueryDeletedLink(linkId, startId, endId)
    ccall((:ax_NodeEditor_QueryDeletedLink, libcimnodes_editor), Bool, (Ptr{LinkId}, Ptr{PinId}, Ptr{PinId}), linkId, startId, endId)
end

function ax_NodeEditor_QueryDeletedNode(nodeId)
    ccall((:ax_NodeEditor_QueryDeletedNode, libcimnodes_editor), Bool, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_AcceptDeletedItem(deleteDependencies)
    ccall((:ax_NodeEditor_AcceptDeletedItem, libcimnodes_editor), Bool, (Bool,), deleteDependencies)
end

function ax_NodeEditor_RejectDeletedItem()
    ccall((:ax_NodeEditor_RejectDeletedItem, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_EndDelete()
    ccall((:ax_NodeEditor_EndDelete, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_SetNodePosition(nodeId, editorPosition)
    ccall((:ax_NodeEditor_SetNodePosition, libcimnodes_editor), Cvoid, (Ptr{NodeId}, ImVec2), nodeId, editorPosition)
end

function ax_NodeEditor_SetGroupSize(nodeId, size)
    ccall((:ax_NodeEditor_SetGroupSize, libcimnodes_editor), Cvoid, (Ptr{NodeId}, ImVec2), nodeId, size)
end

function ax_NodeEditor_GetNodePosition(nodeId)
    ccall((:ax_NodeEditor_GetNodePosition, libcimnodes_editor), ImVec2, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_GetNodeSize(nodeId)
    ccall((:ax_NodeEditor_GetNodeSize, libcimnodes_editor), ImVec2, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_CenterNodeOnScreen(nodeId)
    ccall((:ax_NodeEditor_CenterNodeOnScreen, libcimnodes_editor), Cvoid, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_SetNodeZPosition(nodeId, z)
    ccall((:ax_NodeEditor_SetNodeZPosition, libcimnodes_editor), Cvoid, (Ptr{NodeId}, Cfloat), nodeId, z)
end

function ax_NodeEditor_GetNodeZPosition(nodeId)
    ccall((:ax_NodeEditor_GetNodeZPosition, libcimnodes_editor), Cfloat, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_RestoreNodeState(nodeId)
    ccall((:ax_NodeEditor_RestoreNodeState, libcimnodes_editor), Cvoid, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_Suspend()
    ccall((:ax_NodeEditor_Suspend, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_Resume()
    ccall((:ax_NodeEditor_Resume, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_IsSuspended()
    ccall((:ax_NodeEditor_IsSuspended, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_IsActive()
    ccall((:ax_NodeEditor_IsActive, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_HasSelectionChanged()
    ccall((:ax_NodeEditor_HasSelectionChanged, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_GetSelectedObjectCount()
    ccall((:ax_NodeEditor_GetSelectedObjectCount, libcimnodes_editor), Cint, ())
end

function ax_NodeEditor_GetSelectedNodes(nodes, size)
    ccall((:ax_NodeEditor_GetSelectedNodes, libcimnodes_editor), Cint, (Ptr{NodeId}, Cint), nodes, size)
end

function ax_NodeEditor_GetSelectedLinks(links, size)
    ccall((:ax_NodeEditor_GetSelectedLinks, libcimnodes_editor), Cint, (Ptr{LinkId}, Cint), links, size)
end

function ax_NodeEditor_IsNodeSelected(nodeId)
    ccall((:ax_NodeEditor_IsNodeSelected, libcimnodes_editor), Bool, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_IsLinkSelected(linkId)
    ccall((:ax_NodeEditor_IsLinkSelected, libcimnodes_editor), Bool, (Ptr{LinkId},), linkId)
end

function ax_NodeEditor_ClearSelection()
    ccall((:ax_NodeEditor_ClearSelection, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_SelectNode(nodeId, append)
    ccall((:ax_NodeEditor_SelectNode, libcimnodes_editor), Cvoid, (Ptr{NodeId}, Bool), nodeId, append)
end

function ax_NodeEditor_SelectLink(linkId, append)
    ccall((:ax_NodeEditor_SelectLink, libcimnodes_editor), Cvoid, (Ptr{LinkId}, Bool), linkId, append)
end

function ax_NodeEditor_DeselectNode(nodeId)
    ccall((:ax_NodeEditor_DeselectNode, libcimnodes_editor), Cvoid, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_DeselectLink(linkId)
    ccall((:ax_NodeEditor_DeselectLink, libcimnodes_editor), Cvoid, (Ptr{LinkId},), linkId)
end

function ax_NodeEditor_DeleteNode(nodeId)
    ccall((:ax_NodeEditor_DeleteNode, libcimnodes_editor), Bool, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_DeleteLink(linkId)
    ccall((:ax_NodeEditor_DeleteLink, libcimnodes_editor), Bool, (Ptr{LinkId},), linkId)
end

function ax_NodeEditor_HasAnyLinks_NodeId(nodeId)
    ccall((:ax_NodeEditor_HasAnyLinks_NodeId, libcimnodes_editor), Bool, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_HasAnyLinks_PinId(pinId)
    ccall((:ax_NodeEditor_HasAnyLinks_PinId, libcimnodes_editor), Bool, (Ptr{PinId},), pinId)
end

function ax_NodeEditor_BreakLinks_NodeId(nodeId)
    ccall((:ax_NodeEditor_BreakLinks_NodeId, libcimnodes_editor), Cint, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_BreakLinks_PinId(pinId)
    ccall((:ax_NodeEditor_BreakLinks_PinId, libcimnodes_editor), Cint, (Ptr{PinId},), pinId)
end

function ax_NodeEditor_NavigateToContent(duration)
    ccall((:ax_NodeEditor_NavigateToContent, libcimnodes_editor), Cvoid, (Cfloat,), duration)
end

function ax_NodeEditor_NavigateToSelection(zoomIn, duration)
    ccall((:ax_NodeEditor_NavigateToSelection, libcimnodes_editor), Cvoid, (Bool, Cfloat), zoomIn, duration)
end

function ax_NodeEditor_ShowNodeContextMenu(nodeId)
    ccall((:ax_NodeEditor_ShowNodeContextMenu, libcimnodes_editor), Bool, (Ptr{NodeId},), nodeId)
end

function ax_NodeEditor_ShowPinContextMenu(pinId)
    ccall((:ax_NodeEditor_ShowPinContextMenu, libcimnodes_editor), Bool, (Ptr{PinId},), pinId)
end

function ax_NodeEditor_ShowLinkContextMenu(linkId)
    ccall((:ax_NodeEditor_ShowLinkContextMenu, libcimnodes_editor), Bool, (Ptr{LinkId},), linkId)
end

function ax_NodeEditor_ShowBackgroundContextMenu()
    ccall((:ax_NodeEditor_ShowBackgroundContextMenu, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_EnableShortcuts(enable)
    ccall((:ax_NodeEditor_EnableShortcuts, libcimnodes_editor), Cvoid, (Bool,), enable)
end

function ax_NodeEditor_AreShortcutsEnabled()
    ccall((:ax_NodeEditor_AreShortcutsEnabled, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_BeginShortcut()
    ccall((:ax_NodeEditor_BeginShortcut, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_AcceptCut()
    ccall((:ax_NodeEditor_AcceptCut, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_AcceptCopy()
    ccall((:ax_NodeEditor_AcceptCopy, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_AcceptPaste()
    ccall((:ax_NodeEditor_AcceptPaste, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_AcceptDuplicate()
    ccall((:ax_NodeEditor_AcceptDuplicate, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_AcceptCreateNode()
    ccall((:ax_NodeEditor_AcceptCreateNode, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_GetActionContextSize()
    ccall((:ax_NodeEditor_GetActionContextSize, libcimnodes_editor), Cint, ())
end

function ax_NodeEditor_GetActionContextNodes(nodes, size)
    ccall((:ax_NodeEditor_GetActionContextNodes, libcimnodes_editor), Cint, (Ptr{NodeId}, Cint), nodes, size)
end

function ax_NodeEditor_GetActionContextLinks(links, size)
    ccall((:ax_NodeEditor_GetActionContextLinks, libcimnodes_editor), Cint, (Ptr{LinkId}, Cint), links, size)
end

function ax_NodeEditor_EndShortcut()
    ccall((:ax_NodeEditor_EndShortcut, libcimnodes_editor), Cvoid, ())
end

function ax_NodeEditor_GetCurrentZoom()
    ccall((:ax_NodeEditor_GetCurrentZoom, libcimnodes_editor), Cfloat, ())
end

function ax_NodeEditor_GetHoveredNode()
    ccall((:ax_NodeEditor_GetHoveredNode, libcimnodes_editor), Ptr{NodeId}, ())
end

function ax_NodeEditor_GetHoveredPin()
    ccall((:ax_NodeEditor_GetHoveredPin, libcimnodes_editor), Ptr{PinId}, ())
end

function ax_NodeEditor_GetHoveredLink()
    ccall((:ax_NodeEditor_GetHoveredLink, libcimnodes_editor), Ptr{LinkId}, ())
end

function ax_NodeEditor_GetDoubleClickedNode()
    ccall((:ax_NodeEditor_GetDoubleClickedNode, libcimnodes_editor), Ptr{NodeId}, ())
end

function ax_NodeEditor_GetDoubleClickedPin()
    ccall((:ax_NodeEditor_GetDoubleClickedPin, libcimnodes_editor), Ptr{PinId}, ())
end

function ax_NodeEditor_GetDoubleClickedLink()
    ccall((:ax_NodeEditor_GetDoubleClickedLink, libcimnodes_editor), Ptr{LinkId}, ())
end

function ax_NodeEditor_IsBackgroundClicked()
    ccall((:ax_NodeEditor_IsBackgroundClicked, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_IsBackgroundDoubleClicked()
    ccall((:ax_NodeEditor_IsBackgroundDoubleClicked, libcimnodes_editor), Bool, ())
end

function ax_NodeEditor_GetBackgroundClickButtonIndex()
    ccall((:ax_NodeEditor_GetBackgroundClickButtonIndex, libcimnodes_editor), ImGuiMouseButton, ())
end

function ax_NodeEditor_GetBackgroundDoubleClickButtonIndex()
    ccall((:ax_NodeEditor_GetBackgroundDoubleClickButtonIndex, libcimnodes_editor), ImGuiMouseButton, ())
end

function ax_NodeEditor_GetLinkPins(linkId, startPinId, endPinId)
    ccall((:ax_NodeEditor_GetLinkPins, libcimnodes_editor), Bool, (Ptr{LinkId}, Ptr{PinId}, Ptr{PinId}), linkId, startPinId, endPinId)
end

function ax_NodeEditor_PinHadAnyLinks(pinId)
    ccall((:ax_NodeEditor_PinHadAnyLinks, libcimnodes_editor), Bool, (Ptr{PinId},), pinId)
end

function ax_NodeEditor_GetScreenSize()
    ccall((:ax_NodeEditor_GetScreenSize, libcimnodes_editor), ImVec2, ())
end

function ax_NodeEditor_ScreenToCanvas(pos)
    ccall((:ax_NodeEditor_ScreenToCanvas, libcimnodes_editor), ImVec2, (ImVec2,), pos)
end

function ax_NodeEditor_CanvasToScreen(pos)
    ccall((:ax_NodeEditor_CanvasToScreen, libcimnodes_editor), ImVec2, (ImVec2,), pos)
end

function ax_NodeEditor_GetNodeCount()
    ccall((:ax_NodeEditor_GetNodeCount, libcimnodes_editor), Cint, ())
end

function ax_NodeEditor_GetOrderedNodeIds(nodes, size)
    ccall((:ax_NodeEditor_GetOrderedNodeIds, libcimnodes_editor), Cint, (Ptr{NodeId}, Cint), nodes, size)
end

function ax_NodeEditor_NodeId(val)
    ccall((:ax_NodeEditor_NodeId, libcimnodes_editor), Ptr{NodeId}, (Csize_t,), val)
end

function ax_NodeEditor_NodeId_destroy(self)
    ccall((:ax_NodeEditor_NodeId_destroy, libcimnodes_editor), Cvoid, (Ptr{NodeId},), self)
end

function ax_NodeEditor_PinId(val)
    ccall((:ax_NodeEditor_PinId, libcimnodes_editor), Ptr{PinId}, (Csize_t,), val)
end

function ax_NodeEditor_PinId_destroy(self)
    ccall((:ax_NodeEditor_PinId_destroy, libcimnodes_editor), Cvoid, (Ptr{PinId},), self)
end

function ax_NodeEditor_LinkId(val)
    ccall((:ax_NodeEditor_LinkId, libcimnodes_editor), Ptr{LinkId}, (Csize_t,), val)
end

function ax_NodeEditor_LinkId_destroy(self)
    ccall((:ax_NodeEditor_LinkId_destroy, libcimnodes_editor), Cvoid, (Ptr{LinkId},), self)
end

function ax_NodeEditor_NodeId_value(self)
    ccall((:ax_NodeEditor_NodeId_value, libcimnodes_editor), Csize_t, (Ptr{NodeId},), self)
end

function ax_NodeEditor_PinId_value(self)
    ccall((:ax_NodeEditor_PinId_value, libcimnodes_editor), Csize_t, (Ptr{PinId},), self)
end

function ax_NodeEditor_LinkId_value(self)
    ccall((:ax_NodeEditor_LinkId_value, libcimnodes_editor), Csize_t, (Ptr{LinkId},), self)
end

end # module
