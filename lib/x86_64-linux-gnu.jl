module lib

using CEnum: CEnum, @cenum

using cimnodes_editor_jll: libcimnodes_editor

using CImGui: ImVec2, ImVec4, ImVector_float, ImDrawList, ImGuiMouseButton


struct LinkId
    value::Csize_t
end

const LinkId = LinkId

struct NodeId
    value::Csize_t
end

const NodeId = NodeId

struct PinId
    value::Csize_t
end

const PinId = PinId

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


function ax_NodeEditor_Config_Config_Config()
    @ccall libcimnodes_editor.ax_NodeEditor_Config_Config_Config()::Ptr{Config}
end

function Config_destroy(self)
    @ccall libcimnodes_editor.Config_destroy(self::Ptr{Config})::Cvoid
end

function ax_NodeEditor_SetCurrentEditor(ctx)
    @ccall libcimnodes_editor.ax_NodeEditor_SetCurrentEditor(ctx::Ptr{EditorContext})::Cvoid
end

function ax_NodeEditor_GetCurrentEditor()
    @ccall libcimnodes_editor.ax_NodeEditor_GetCurrentEditor()::Ptr{EditorContext}
end

function ax_NodeEditor_CreateEditor(config)
    @ccall libcimnodes_editor.ax_NodeEditor_CreateEditor(config::Ptr{Config})::Ptr{EditorContext}
end

function ax_NodeEditor_DestroyEditor(ctx)
    @ccall libcimnodes_editor.ax_NodeEditor_DestroyEditor(ctx::Ptr{EditorContext})::Cvoid
end

function ax_NodeEditor_GetConfig(ctx)
    @ccall libcimnodes_editor.ax_NodeEditor_GetConfig(ctx::Ptr{EditorContext})::Ptr{Config}
end

function ax_NodeEditor_GetStyle()
    @ccall libcimnodes_editor.ax_NodeEditor_GetStyle()::Ptr{cimnodes_editor_Style}
end

function ax_NodeEditor_GetStyleColorName(colorIndex)
    @ccall libcimnodes_editor.ax_NodeEditor_GetStyleColorName(colorIndex::StyleColor)::Ptr{Cchar}
end

function ax_NodeEditor_PushStyleColor(colorIndex, color)
    @ccall libcimnodes_editor.ax_NodeEditor_PushStyleColor(colorIndex::StyleColor, color::ImVec4)::Cvoid
end

function ax_NodeEditor_PopStyleColor(count)
    @ccall libcimnodes_editor.ax_NodeEditor_PopStyleColor(count::Cint)::Cvoid
end

function ax_NodeEditor_PushStyleVar_Float(varIndex, value)
    @ccall libcimnodes_editor.ax_NodeEditor_PushStyleVar_Float(varIndex::StyleVar, value::Cfloat)::Cvoid
end

function ax_NodeEditor_PushStyleVar_Vec2(varIndex, value)
    @ccall libcimnodes_editor.ax_NodeEditor_PushStyleVar_Vec2(varIndex::StyleVar, value::ImVec2)::Cvoid
end

function ax_NodeEditor_PushStyleVar_Vec4(varIndex, value)
    @ccall libcimnodes_editor.ax_NodeEditor_PushStyleVar_Vec4(varIndex::StyleVar, value::ImVec4)::Cvoid
end

function ax_NodeEditor_PopStyleVar(count)
    @ccall libcimnodes_editor.ax_NodeEditor_PopStyleVar(count::Cint)::Cvoid
end

function ax_NodeEditor_Begin(id, size)
    @ccall libcimnodes_editor.ax_NodeEditor_Begin(id::Ptr{Cchar}, size::ImVec2)::Cvoid
end

function ax_NodeEditor_End()
    @ccall libcimnodes_editor.ax_NodeEditor_End()::Cvoid
end

function ax_NodeEditor_BeginNode(id)
    @ccall libcimnodes_editor.ax_NodeEditor_BeginNode(id::NodeId)::Cvoid
end

function ax_NodeEditor_BeginPin(id, kind)
    @ccall libcimnodes_editor.ax_NodeEditor_BeginPin(id::PinId, kind::PinKind)::Cvoid
end

function ax_NodeEditor_PinRect(a, b)
    @ccall libcimnodes_editor.ax_NodeEditor_PinRect(a::ImVec2, b::ImVec2)::Cvoid
end

function ax_NodeEditor_PinPivotRect(a, b)
    @ccall libcimnodes_editor.ax_NodeEditor_PinPivotRect(a::ImVec2, b::ImVec2)::Cvoid
end

function ax_NodeEditor_PinPivotSize(size)
    @ccall libcimnodes_editor.ax_NodeEditor_PinPivotSize(size::ImVec2)::Cvoid
end

function ax_NodeEditor_PinPivotScale(scale)
    @ccall libcimnodes_editor.ax_NodeEditor_PinPivotScale(scale::ImVec2)::Cvoid
end

function ax_NodeEditor_PinPivotAlignment(alignment)
    @ccall libcimnodes_editor.ax_NodeEditor_PinPivotAlignment(alignment::ImVec2)::Cvoid
end

function ax_NodeEditor_EndPin()
    @ccall libcimnodes_editor.ax_NodeEditor_EndPin()::Cvoid
end

function ax_NodeEditor_Group(size)
    @ccall libcimnodes_editor.ax_NodeEditor_Group(size::ImVec2)::Cvoid
end

function ax_NodeEditor_EndNode()
    @ccall libcimnodes_editor.ax_NodeEditor_EndNode()::Cvoid
end

function ax_NodeEditor_BeginGroupHint(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_BeginGroupHint(nodeId::NodeId)::Bool
end

function ax_NodeEditor_GetGroupMin()
    @ccall libcimnodes_editor.ax_NodeEditor_GetGroupMin()::ImVec2
end

function ax_NodeEditor_GetGroupMax()
    @ccall libcimnodes_editor.ax_NodeEditor_GetGroupMax()::ImVec2
end

function ax_NodeEditor_GetHintForegroundDrawList()
    @ccall libcimnodes_editor.ax_NodeEditor_GetHintForegroundDrawList()::Ptr{ImDrawList}
end

function ax_NodeEditor_GetHintBackgroundDrawList()
    @ccall libcimnodes_editor.ax_NodeEditor_GetHintBackgroundDrawList()::Ptr{ImDrawList}
end

function ax_NodeEditor_EndGroupHint()
    @ccall libcimnodes_editor.ax_NodeEditor_EndGroupHint()::Cvoid
end

function ax_NodeEditor_GetNodeBackgroundDrawList(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_GetNodeBackgroundDrawList(nodeId::NodeId)::Ptr{ImDrawList}
end

function ax_NodeEditor_Link(id, startPinId, endPinId, color, thickness)
    @ccall libcimnodes_editor.ax_NodeEditor_Link(id::LinkId, startPinId::PinId, endPinId::PinId, color::ImVec4, thickness::Cfloat)::Bool
end

function ax_NodeEditor_Flow(linkId, direction)
    @ccall libcimnodes_editor.ax_NodeEditor_Flow(linkId::LinkId, direction::FlowDirection)::Cvoid
end

function ax_NodeEditor_BeginCreate(color, thickness)
    @ccall libcimnodes_editor.ax_NodeEditor_BeginCreate(color::ImVec4, thickness::Cfloat)::Bool
end

function ax_NodeEditor_QueryNewLink_Nil(startId, endId)
    @ccall libcimnodes_editor.ax_NodeEditor_QueryNewLink_Nil(startId::Ptr{PinId}, endId::Ptr{PinId})::Bool
end

function ax_NodeEditor_QueryNewLink_Vec4(startId, endId, color, thickness)
    @ccall libcimnodes_editor.ax_NodeEditor_QueryNewLink_Vec4(startId::Ptr{PinId}, endId::Ptr{PinId}, color::ImVec4, thickness::Cfloat)::Bool
end

function ax_NodeEditor_QueryNewNode_Nil(pinId)
    @ccall libcimnodes_editor.ax_NodeEditor_QueryNewNode_Nil(pinId::Ptr{PinId})::Bool
end

function ax_NodeEditor_QueryNewNode_Vec4(pinId, color, thickness)
    @ccall libcimnodes_editor.ax_NodeEditor_QueryNewNode_Vec4(pinId::Ptr{PinId}, color::ImVec4, thickness::Cfloat)::Bool
end

function ax_NodeEditor_AcceptNewItem_Nil()
    @ccall libcimnodes_editor.ax_NodeEditor_AcceptNewItem_Nil()::Bool
end

function ax_NodeEditor_AcceptNewItem_Vec4(color, thickness)
    @ccall libcimnodes_editor.ax_NodeEditor_AcceptNewItem_Vec4(color::ImVec4, thickness::Cfloat)::Bool
end

function ax_NodeEditor_RejectNewItem_Nil()
    @ccall libcimnodes_editor.ax_NodeEditor_RejectNewItem_Nil()::Cvoid
end

function ax_NodeEditor_RejectNewItem_Vec4(color, thickness)
    @ccall libcimnodes_editor.ax_NodeEditor_RejectNewItem_Vec4(color::ImVec4, thickness::Cfloat)::Cvoid
end

function ax_NodeEditor_EndCreate()
    @ccall libcimnodes_editor.ax_NodeEditor_EndCreate()::Cvoid
end

function ax_NodeEditor_BeginDelete()
    @ccall libcimnodes_editor.ax_NodeEditor_BeginDelete()::Bool
end

function ax_NodeEditor_QueryDeletedLink(linkId, startId, endId)
    @ccall libcimnodes_editor.ax_NodeEditor_QueryDeletedLink(linkId::Ptr{LinkId}, startId::Ptr{PinId}, endId::Ptr{PinId})::Bool
end

function ax_NodeEditor_QueryDeletedNode(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_QueryDeletedNode(nodeId::Ptr{NodeId})::Bool
end

function ax_NodeEditor_AcceptDeletedItem(deleteDependencies)
    @ccall libcimnodes_editor.ax_NodeEditor_AcceptDeletedItem(deleteDependencies::Bool)::Bool
end

function ax_NodeEditor_RejectDeletedItem()
    @ccall libcimnodes_editor.ax_NodeEditor_RejectDeletedItem()::Cvoid
end

function ax_NodeEditor_EndDelete()
    @ccall libcimnodes_editor.ax_NodeEditor_EndDelete()::Cvoid
end

function ax_NodeEditor_SetNodePosition(nodeId, editorPosition)
    @ccall libcimnodes_editor.ax_NodeEditor_SetNodePosition(nodeId::NodeId, editorPosition::ImVec2)::Cvoid
end

function ax_NodeEditor_SetGroupSize(nodeId, size)
    @ccall libcimnodes_editor.ax_NodeEditor_SetGroupSize(nodeId::NodeId, size::ImVec2)::Cvoid
end

function ax_NodeEditor_GetNodePosition(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_GetNodePosition(nodeId::NodeId)::ImVec2
end

function ax_NodeEditor_GetNodeSize(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_GetNodeSize(nodeId::NodeId)::ImVec2
end

function ax_NodeEditor_CenterNodeOnScreen(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_CenterNodeOnScreen(nodeId::NodeId)::Cvoid
end

function ax_NodeEditor_SetNodeZPosition(nodeId, z)
    @ccall libcimnodes_editor.ax_NodeEditor_SetNodeZPosition(nodeId::NodeId, z::Cfloat)::Cvoid
end

function ax_NodeEditor_GetNodeZPosition(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_GetNodeZPosition(nodeId::NodeId)::Cfloat
end

function ax_NodeEditor_RestoreNodeState(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_RestoreNodeState(nodeId::NodeId)::Cvoid
end

function ax_NodeEditor_Suspend()
    @ccall libcimnodes_editor.ax_NodeEditor_Suspend()::Cvoid
end

function ax_NodeEditor_Resume()
    @ccall libcimnodes_editor.ax_NodeEditor_Resume()::Cvoid
end

function ax_NodeEditor_IsSuspended()
    @ccall libcimnodes_editor.ax_NodeEditor_IsSuspended()::Bool
end

function ax_NodeEditor_IsActive()
    @ccall libcimnodes_editor.ax_NodeEditor_IsActive()::Bool
end

function ax_NodeEditor_HasSelectionChanged()
    @ccall libcimnodes_editor.ax_NodeEditor_HasSelectionChanged()::Bool
end

function ax_NodeEditor_GetSelectedObjectCount()
    @ccall libcimnodes_editor.ax_NodeEditor_GetSelectedObjectCount()::Cint
end

function ax_NodeEditor_GetSelectedNodes(nodes, size)
    @ccall libcimnodes_editor.ax_NodeEditor_GetSelectedNodes(nodes::Ptr{NodeId}, size::Cint)::Cint
end

function ax_NodeEditor_GetSelectedLinks(links, size)
    @ccall libcimnodes_editor.ax_NodeEditor_GetSelectedLinks(links::Ptr{LinkId}, size::Cint)::Cint
end

function ax_NodeEditor_IsNodeSelected(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_IsNodeSelected(nodeId::NodeId)::Bool
end

function ax_NodeEditor_IsLinkSelected(linkId)
    @ccall libcimnodes_editor.ax_NodeEditor_IsLinkSelected(linkId::LinkId)::Bool
end

function ax_NodeEditor_ClearSelection()
    @ccall libcimnodes_editor.ax_NodeEditor_ClearSelection()::Cvoid
end

function ax_NodeEditor_SelectNode(nodeId, append)
    @ccall libcimnodes_editor.ax_NodeEditor_SelectNode(nodeId::NodeId, append::Bool)::Cvoid
end

function ax_NodeEditor_SelectLink(linkId, append)
    @ccall libcimnodes_editor.ax_NodeEditor_SelectLink(linkId::LinkId, append::Bool)::Cvoid
end

function ax_NodeEditor_DeselectNode(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_DeselectNode(nodeId::NodeId)::Cvoid
end

function ax_NodeEditor_DeselectLink(linkId)
    @ccall libcimnodes_editor.ax_NodeEditor_DeselectLink(linkId::LinkId)::Cvoid
end

function ax_NodeEditor_DeleteNode(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_DeleteNode(nodeId::NodeId)::Bool
end

function ax_NodeEditor_DeleteLink(linkId)
    @ccall libcimnodes_editor.ax_NodeEditor_DeleteLink(linkId::LinkId)::Bool
end

function ax_NodeEditor_HasAnyLinks_NodeId(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_HasAnyLinks_NodeId(nodeId::NodeId)::Bool
end

function ax_NodeEditor_HasAnyLinks_PinId(pinId)
    @ccall libcimnodes_editor.ax_NodeEditor_HasAnyLinks_PinId(pinId::PinId)::Bool
end

function ax_NodeEditor_BreakLinks_NodeId(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_BreakLinks_NodeId(nodeId::NodeId)::Cint
end

function ax_NodeEditor_BreakLinks_PinId(pinId)
    @ccall libcimnodes_editor.ax_NodeEditor_BreakLinks_PinId(pinId::PinId)::Cint
end

function ax_NodeEditor_NavigateToContent(duration)
    @ccall libcimnodes_editor.ax_NodeEditor_NavigateToContent(duration::Cfloat)::Cvoid
end

function ax_NodeEditor_NavigateToSelection(zoomIn, duration)
    @ccall libcimnodes_editor.ax_NodeEditor_NavigateToSelection(zoomIn::Bool, duration::Cfloat)::Cvoid
end

function ax_NodeEditor_ShowNodeContextMenu(nodeId)
    @ccall libcimnodes_editor.ax_NodeEditor_ShowNodeContextMenu(nodeId::Ptr{NodeId})::Bool
end

function ax_NodeEditor_ShowPinContextMenu(pinId)
    @ccall libcimnodes_editor.ax_NodeEditor_ShowPinContextMenu(pinId::Ptr{PinId})::Bool
end

function ax_NodeEditor_ShowLinkContextMenu(linkId)
    @ccall libcimnodes_editor.ax_NodeEditor_ShowLinkContextMenu(linkId::Ptr{LinkId})::Bool
end

function ax_NodeEditor_ShowBackgroundContextMenu()
    @ccall libcimnodes_editor.ax_NodeEditor_ShowBackgroundContextMenu()::Bool
end

function ax_NodeEditor_EnableShortcuts(enable)
    @ccall libcimnodes_editor.ax_NodeEditor_EnableShortcuts(enable::Bool)::Cvoid
end

function ax_NodeEditor_AreShortcutsEnabled()
    @ccall libcimnodes_editor.ax_NodeEditor_AreShortcutsEnabled()::Bool
end

function ax_NodeEditor_BeginShortcut()
    @ccall libcimnodes_editor.ax_NodeEditor_BeginShortcut()::Bool
end

function ax_NodeEditor_AcceptCut()
    @ccall libcimnodes_editor.ax_NodeEditor_AcceptCut()::Bool
end

function ax_NodeEditor_AcceptCopy()
    @ccall libcimnodes_editor.ax_NodeEditor_AcceptCopy()::Bool
end

function ax_NodeEditor_AcceptPaste()
    @ccall libcimnodes_editor.ax_NodeEditor_AcceptPaste()::Bool
end

function ax_NodeEditor_AcceptDuplicate()
    @ccall libcimnodes_editor.ax_NodeEditor_AcceptDuplicate()::Bool
end

function ax_NodeEditor_AcceptCreateNode()
    @ccall libcimnodes_editor.ax_NodeEditor_AcceptCreateNode()::Bool
end

function ax_NodeEditor_GetActionContextSize()
    @ccall libcimnodes_editor.ax_NodeEditor_GetActionContextSize()::Cint
end

function ax_NodeEditor_GetActionContextNodes(nodes, size)
    @ccall libcimnodes_editor.ax_NodeEditor_GetActionContextNodes(nodes::Ptr{NodeId}, size::Cint)::Cint
end

function ax_NodeEditor_GetActionContextLinks(links, size)
    @ccall libcimnodes_editor.ax_NodeEditor_GetActionContextLinks(links::Ptr{LinkId}, size::Cint)::Cint
end

function ax_NodeEditor_EndShortcut()
    @ccall libcimnodes_editor.ax_NodeEditor_EndShortcut()::Cvoid
end

function ax_NodeEditor_GetCurrentZoom()
    @ccall libcimnodes_editor.ax_NodeEditor_GetCurrentZoom()::Cfloat
end

function ax_NodeEditor_GetHoveredNode()
    @ccall libcimnodes_editor.ax_NodeEditor_GetHoveredNode()::NodeId
end

function ax_NodeEditor_GetHoveredPin()
    @ccall libcimnodes_editor.ax_NodeEditor_GetHoveredPin()::PinId
end

function ax_NodeEditor_GetHoveredLink()
    @ccall libcimnodes_editor.ax_NodeEditor_GetHoveredLink()::LinkId
end

function ax_NodeEditor_GetDoubleClickedNode()
    @ccall libcimnodes_editor.ax_NodeEditor_GetDoubleClickedNode()::NodeId
end

function ax_NodeEditor_GetDoubleClickedPin()
    @ccall libcimnodes_editor.ax_NodeEditor_GetDoubleClickedPin()::PinId
end

function ax_NodeEditor_GetDoubleClickedLink()
    @ccall libcimnodes_editor.ax_NodeEditor_GetDoubleClickedLink()::LinkId
end

function ax_NodeEditor_IsBackgroundClicked()
    @ccall libcimnodes_editor.ax_NodeEditor_IsBackgroundClicked()::Bool
end

function ax_NodeEditor_IsBackgroundDoubleClicked()
    @ccall libcimnodes_editor.ax_NodeEditor_IsBackgroundDoubleClicked()::Bool
end

function ax_NodeEditor_GetBackgroundClickButtonIndex()
    @ccall libcimnodes_editor.ax_NodeEditor_GetBackgroundClickButtonIndex()::ImGuiMouseButton
end

function ax_NodeEditor_GetBackgroundDoubleClickButtonIndex()
    @ccall libcimnodes_editor.ax_NodeEditor_GetBackgroundDoubleClickButtonIndex()::ImGuiMouseButton
end

function ax_NodeEditor_GetLinkPins(linkId, startPinId, endPinId)
    @ccall libcimnodes_editor.ax_NodeEditor_GetLinkPins(linkId::LinkId, startPinId::Ptr{PinId}, endPinId::Ptr{PinId})::Bool
end

function ax_NodeEditor_PinHadAnyLinks(pinId)
    @ccall libcimnodes_editor.ax_NodeEditor_PinHadAnyLinks(pinId::PinId)::Bool
end

function ax_NodeEditor_GetScreenSize()
    @ccall libcimnodes_editor.ax_NodeEditor_GetScreenSize()::ImVec2
end

function ax_NodeEditor_ScreenToCanvas(pos)
    @ccall libcimnodes_editor.ax_NodeEditor_ScreenToCanvas(pos::ImVec2)::ImVec2
end

function ax_NodeEditor_CanvasToScreen(pos)
    @ccall libcimnodes_editor.ax_NodeEditor_CanvasToScreen(pos::ImVec2)::ImVec2
end

function ax_NodeEditor_GetNodeCount()
    @ccall libcimnodes_editor.ax_NodeEditor_GetNodeCount()::Cint
end

function ax_NodeEditor_GetOrderedNodeIds(nodes, size)
    @ccall libcimnodes_editor.ax_NodeEditor_GetOrderedNodeIds(nodes::Ptr{NodeId}, size::Cint)::Cint
end

function ax_NodeEditor_NodeId(val)
    @ccall libcimnodes_editor.ax_NodeEditor_NodeId(val::Csize_t)::NodeId
end

function ax_NodeEditor_PinId(val)
    @ccall libcimnodes_editor.ax_NodeEditor_PinId(val::Csize_t)::PinId
end

function ax_NodeEditor_LinkId(val)
    @ccall libcimnodes_editor.ax_NodeEditor_LinkId(val::Csize_t)::LinkId
end

function ax_NodeEditor_NodeId_value(self)
    @ccall libcimnodes_editor.ax_NodeEditor_NodeId_value(self::NodeId)::Csize_t
end

function ax_NodeEditor_PinId_value(self)
    @ccall libcimnodes_editor.ax_NodeEditor_PinId_value(self::PinId)::Csize_t
end

function ax_NodeEditor_LinkId_value(self)
    @ccall libcimnodes_editor.ax_NodeEditor_LinkId_value(self::LinkId)::Csize_t
end

end # module
