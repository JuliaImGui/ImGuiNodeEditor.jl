const NodeId = lib.NodeId
const LinkId = lib.LinkId
const PinId = lib.PinId
const EditorContext = lib.EditorContext
const Config = lib.Config
const SafeType = lib.SafeType
const SafePointerType = lib.SafePointerType

const PinKind = lib.PinKind
const PinKind_Input = lib.Input
const PinKind_Output = lib.Output

const FlowDirection = lib.FlowDirection
const FlowDirection_Forward = lib.Forward
const FlowDirection_Backward = lib.Backward

const CanvasSizeMode = lib.CanvasSizeMode
const CanvasSizeMode_FitVerticalView = lib.FitVerticalView
const CanvasSizeMode_FitHorizontalView = lib.FitHorizontalView
const CanvasSizeMode_CenterOnly = lib.CenterOnly

const SaveReasonFlags = lib.SaveReasonFlags
const SaveReasonFlags_None = lib.None
const SaveReasonFlags_Navigation = lib.Navigation
const SaveReasonFlags_Position = lib.Position
const SaveReasonFlags_Size = lib.Size
const SaveReasonFlags_Selection = lib.Selection
const SaveReasonFlags_AddNode = lib.AddNode
const SaveReasonFlags_RemoveNode = lib.RemoveNode
const SaveReasonFlags_User = lib.User

const StyleColor = lib.StyleColor
const StyleColor_Bg = lib.StyleColor_Bg
const StyleColor_Grid = lib.StyleColor_Grid
const StyleColor_NodeBg = lib.StyleColor_NodeBg
const StyleColor_NodeBorder = lib.StyleColor_NodeBorder
const StyleColor_HovNodeBorder = lib.StyleColor_HovNodeBorder
const StyleColor_SelNodeBorder = lib.StyleColor_SelNodeBorder
const StyleColor_NodeSelRect = lib.StyleColor_NodeSelRect
const StyleColor_NodeSelRectBorder = lib.StyleColor_NodeSelRectBorder
const StyleColor_HovLinkBorder = lib.StyleColor_HovLinkBorder
const StyleColor_SelLinkBorder = lib.StyleColor_SelLinkBorder
const StyleColor_HighlightLinkBorder = lib.StyleColor_HighlightLinkBorder
const StyleColor_LinkSelRect = lib.StyleColor_LinkSelRect
const StyleColor_LinkSelRectBorder = lib.StyleColor_LinkSelRectBorder
const StyleColor_PinRect = lib.StyleColor_PinRect
const StyleColor_PinRectBorder = lib.StyleColor_PinRectBorder
const StyleColor_Flow = lib.StyleColor_Flow
const StyleColor_FlowMarker = lib.StyleColor_FlowMarker
const StyleColor_GroupBg = lib.StyleColor_GroupBg
const StyleColor_GroupBorder = lib.StyleColor_GroupBorder
const StyleColor_Count = lib.StyleColor_Count

const StyleVar = lib.StyleVar
const StyleVar_NodePadding = lib.StyleVar_NodePadding
const StyleVar_NodeRounding = lib.StyleVar_NodeRounding
const StyleVar_NodeBorderWidth = lib.StyleVar_NodeBorderWidth
const StyleVar_HoveredNodeBorderWidth = lib.StyleVar_HoveredNodeBorderWidth
const StyleVar_SelectedNodeBorderWidth = lib.StyleVar_SelectedNodeBorderWidth
const StyleVar_PinRounding = lib.StyleVar_PinRounding
const StyleVar_PinBorderWidth = lib.StyleVar_PinBorderWidth
const StyleVar_LinkStrength = lib.StyleVar_LinkStrength
const StyleVar_SourceDirection = lib.StyleVar_SourceDirection
const StyleVar_TargetDirection = lib.StyleVar_TargetDirection
const StyleVar_ScrollDuration = lib.StyleVar_ScrollDuration
const StyleVar_FlowMarkerDistance = lib.StyleVar_FlowMarkerDistance
const StyleVar_FlowSpeed = lib.StyleVar_FlowSpeed
const StyleVar_FlowDuration = lib.StyleVar_FlowDuration
const StyleVar_PivotAlignment = lib.StyleVar_PivotAlignment
const StyleVar_PivotSize = lib.StyleVar_PivotSize
const StyleVar_PivotScale = lib.StyleVar_PivotScale
const StyleVar_PinCorners = lib.StyleVar_PinCorners
const StyleVar_PinRadius = lib.StyleVar_PinRadius
const StyleVar_PinArrowSize = lib.StyleVar_PinArrowSize
const StyleVar_PinArrowWidth = lib.StyleVar_PinArrowWidth
const StyleVar_GroupRounding = lib.StyleVar_GroupRounding
const StyleVar_GroupBorderWidth = lib.StyleVar_GroupBorderWidth
const StyleVar_HighlightConnectedLinks = lib.StyleVar_HighlightConnectedLinks
const StyleVar_SnapLinkToPinDir = lib.StyleVar_SnapLinkToPinDir
const StyleVar_HoveredNodeBorderOffset = lib.StyleVar_HoveredNodeBorderOffset
const StyleVar_SelectedNodeBorderOffset = lib.StyleVar_SelectedNodeBorderOffset
const StyleVar_Count = lib.StyleVar_Count

"""
    NodeId(value::Integer)

Construct an opaque `NodeId` handle (a `Ptr{NodeId}`) from an integer id.
"""
NodeId(value::Integer) = lib.ax_NodeEditor_NodeId(value)

"""
    value(id::Ptr{NodeId})

Return the integer id backing a `NodeId` handle.
"""
value(id::Ptr{NodeId}) = lib.ax_NodeEditor_NodeId_value(id)

"""
Destructor for `NodeId`.
"""
Destroy(id::Ptr{NodeId}) = lib.ax_NodeEditor_NodeId_destroy(id)

"""
    PinId(value::Integer)

Construct an opaque `PinId` handle (a `Ptr{PinId}`) from an integer id.
"""
PinId(value::Integer) = lib.ax_NodeEditor_PinId(value)

"""
    value(id::Ptr{PinId})

Return the integer id backing a `PinId` handle.
"""
value(id::Ptr{PinId}) = lib.ax_NodeEditor_PinId_value(id)

"""
Destructor for `PinId`.
"""
Destroy(id::Ptr{PinId}) = lib.ax_NodeEditor_PinId_destroy(id)

"""
    LinkId(value::Integer)

Construct an opaque `LinkId` handle (a `Ptr{LinkId}`) from an integer id.
"""
LinkId(value::Integer) = lib.ax_NodeEditor_LinkId(value)

"""
    value(id::Ptr{LinkId})

Return the integer id backing a `LinkId` handle.
"""
value(id::Ptr{LinkId}) = lib.ax_NodeEditor_LinkId_value(id)

"""
Destructor for `LinkId`.
"""
Destroy(id::Ptr{LinkId}) = lib.ax_NodeEditor_LinkId_destroy(id)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L111).
"""
lib.Config() = lib.ax_NodeEditor_Config_Config_Config()

"""
Destructor for `Config`
"""
Destroy(self::Ptr{Config}) = lib.Config_destroy(self)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L289).
"""
SetCurrentEditor(ctx) = lib.ax_NodeEditor_SetCurrentEditor(ctx)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L290).
"""
GetCurrentEditor() = lib.ax_NodeEditor_GetCurrentEditor()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L291).
"""
CreateEditor(config = C_NULL) = lib.ax_NodeEditor_CreateEditor(config)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L292).
"""
DestroyEditor(ctx) = lib.ax_NodeEditor_DestroyEditor(ctx)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L293).
"""
GetConfig(ctx = C_NULL) = lib.ax_NodeEditor_GetConfig(ctx)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L295).
"""
GetStyle() = lib.ax_NodeEditor_GetStyle()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L296).
"""
GetStyleColorName(colorIndex) = lib.ax_NodeEditor_GetStyleColorName(colorIndex)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L298).
"""
PushStyleColor(colorIndex, color::Union{ImVec4,NTuple{4}}) = lib.ax_NodeEditor_PushStyleColor(colorIndex, color)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L299).
"""
PopStyleColor(count = 1) = lib.ax_NodeEditor_PopStyleColor(count)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L301).
"""
PushStyleVar(varIndex::StyleVar, value::Real) = lib.ax_NodeEditor_PushStyleVar_Float(varIndex, value)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L302).
"""
PushStyleVar(varIndex::StyleVar, value::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PushStyleVar_Vec2(varIndex, value)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L303).
"""
PushStyleVar(varIndex::StyleVar, value::Union{ImVec4,NTuple{4}}) = lib.ax_NodeEditor_PushStyleVar_Vec4(varIndex, value)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L304).
"""
PopStyleVar(count = 1) = lib.ax_NodeEditor_PopStyleVar(count)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L306).
"""
Begin(id, size::Union{ImVec2,NTuple{2}} = ImVec2(0, 0)) = lib.ax_NodeEditor_Begin(id, size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L307).
"""
End() = lib.ax_NodeEditor_End()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L309).
"""
BeginNode(id::Ptr{NodeId}) = lib.ax_NodeEditor_BeginNode(id)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L310).
"""
BeginPin(id::Ptr{PinId}, kind) = lib.ax_NodeEditor_BeginPin(id, kind)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L311).
"""
PinRect(a::Union{ImVec2,NTuple{2}}, b::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PinRect(a, b)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L312).
"""
PinPivotRect(a::Union{ImVec2,NTuple{2}}, b::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PinPivotRect(a, b)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L313).
"""
PinPivotSize(size::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PinPivotSize(size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L314).
"""
PinPivotScale(scale::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PinPivotScale(scale)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L315).
"""
PinPivotAlignment(alignment::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PinPivotAlignment(alignment)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L316).
"""
EndPin() = lib.ax_NodeEditor_EndPin()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L317).
"""
Group(size::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_Group(size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L318).
"""
EndNode() = lib.ax_NodeEditor_EndNode()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L320).
"""
BeginGroupHint(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_BeginGroupHint(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L321).
"""
GetGroupMin() = lib.ax_NodeEditor_GetGroupMin()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L322).
"""
GetGroupMax() = lib.ax_NodeEditor_GetGroupMax()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L323).
"""
GetHintForegroundDrawList() = lib.ax_NodeEditor_GetHintForegroundDrawList()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L324).
"""
GetHintBackgroundDrawList() = lib.ax_NodeEditor_GetHintBackgroundDrawList()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L325).
"""
EndGroupHint() = lib.ax_NodeEditor_EndGroupHint()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L328).
"""
GetNodeBackgroundDrawList(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_GetNodeBackgroundDrawList(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L330).
"""
Link(
    id,
    startPinId::Ptr{PinId},
    endPinId::Ptr{PinId},
    color::Union{ImVec4,NTuple{4}} = ImVec4(1, 1, 1, 1),
    thickness = 1.0f0,
) = lib.ax_NodeEditor_Link(id, startPinId, endPinId, color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L332).
"""
Flow(linkId, direction = FlowDirection::Forward) = lib.ax_NodeEditor_Flow(linkId, direction)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L334).
"""
BeginCreate(color::Union{ImVec4,NTuple{4}} = ImVec4(1, 1, 1, 1), thickness = 1.0f0) =
    lib.ax_NodeEditor_BeginCreate(color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L335).
"""
QueryNewLink(startId::Ptr{PinId}, endId::Ptr{PinId}) = lib.ax_NodeEditor_QueryNewLink_Nil(startId, endId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L336).
"""
QueryNewLink(startId::Ptr{PinId}, endId::Ptr{PinId}, color::Union{ImVec4,NTuple{4}}, thickness::Real = 1.0f0) =
    lib.ax_NodeEditor_QueryNewLink_Vec4(startId, endId, color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L337).
"""
QueryNewNode(pinId::Ptr{PinId}) = lib.ax_NodeEditor_QueryNewNode_Nil(pinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L338).
"""
QueryNewNode(pinId::Ptr{PinId}, color::Union{ImVec4,NTuple{4}}, thickness::Real = 1.0f0) =
    lib.ax_NodeEditor_QueryNewNode_Vec4(pinId, color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L339).
"""
AcceptNewItem() = lib.ax_NodeEditor_AcceptNewItem_Nil()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L340).
"""
AcceptNewItem(color::Union{ImVec4,NTuple{4}}, thickness::Real = 1.0f0) =
    lib.ax_NodeEditor_AcceptNewItem_Vec4(color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L341).
"""
RejectNewItem() = lib.ax_NodeEditor_RejectNewItem_Nil()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L342).
"""
RejectNewItem(color::Union{ImVec4,NTuple{4}}, thickness::Real = 1.0f0) =
    lib.ax_NodeEditor_RejectNewItem_Vec4(color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L343).
"""
EndCreate() = lib.ax_NodeEditor_EndCreate()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L345).
"""
BeginDelete() = lib.ax_NodeEditor_BeginDelete()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L346).
"""
QueryDeletedLink(linkId, startId::Ptr{PinId} = Ptr{PinId}(C_NULL), endId::Ptr{PinId} = Ptr{PinId}(C_NULL)) =
    lib.ax_NodeEditor_QueryDeletedLink(linkId, startId, endId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L347).
"""
QueryDeletedNode(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_QueryDeletedNode(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L348).
"""
AcceptDeletedItem(deleteDependencies = true) = lib.ax_NodeEditor_AcceptDeletedItem(deleteDependencies)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L349).
"""
RejectDeletedItem() = lib.ax_NodeEditor_RejectDeletedItem()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L350).
"""
EndDelete() = lib.ax_NodeEditor_EndDelete()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L352).
"""
SetNodePosition(nodeId::Ptr{NodeId}, editorPosition::Union{ImVec2,NTuple{2}}) =
    lib.ax_NodeEditor_SetNodePosition(nodeId, editorPosition)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L353).
"""
SetGroupSize(nodeId::Ptr{NodeId}, size::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_SetGroupSize(nodeId, size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L354).
"""
GetNodePosition(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_GetNodePosition(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L355).
"""
GetNodeSize(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_GetNodeSize(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L356).
"""
CenterNodeOnScreen(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_CenterNodeOnScreen(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L357).
"""
SetNodeZPosition(nodeId::Ptr{NodeId}, z) = lib.ax_NodeEditor_SetNodeZPosition(nodeId, z)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L358).
"""
GetNodeZPosition(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_GetNodeZPosition(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L360).
"""
RestoreNodeState(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_RestoreNodeState(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L362).
"""
Suspend() = lib.ax_NodeEditor_Suspend()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L363).
"""
Resume() = lib.ax_NodeEditor_Resume()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L364).
"""
IsSuspended() = lib.ax_NodeEditor_IsSuspended()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L366).
"""
IsActive() = lib.ax_NodeEditor_IsActive()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L368).
"""
HasSelectionChanged() = lib.ax_NodeEditor_HasSelectionChanged()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L369).
"""
GetSelectedObjectCount() = lib.ax_NodeEditor_GetSelectedObjectCount()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L370).
"""
GetSelectedNodes(nodes::Ptr{NodeId}, size) = lib.ax_NodeEditor_GetSelectedNodes(nodes, size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L371).
"""
GetSelectedLinks(links, size) = lib.ax_NodeEditor_GetSelectedLinks(links, size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L372).
"""
IsNodeSelected(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_IsNodeSelected(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L373).
"""
IsLinkSelected(linkId) = lib.ax_NodeEditor_IsLinkSelected(linkId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L374).
"""
ClearSelection() = lib.ax_NodeEditor_ClearSelection()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L375).
"""
SelectNode(nodeId::Ptr{NodeId}, append = false) = lib.ax_NodeEditor_SelectNode(nodeId, append)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L376).
"""
SelectLink(linkId, append = false) = lib.ax_NodeEditor_SelectLink(linkId, append)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L377).
"""
DeselectNode(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_DeselectNode(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L378).
"""
DeselectLink(linkId) = lib.ax_NodeEditor_DeselectLink(linkId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L380).
"""
DeleteNode(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_DeleteNode(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L381).
"""
DeleteLink(linkId) = lib.ax_NodeEditor_DeleteLink(linkId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L383).
"""
HasAnyLinks(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_HasAnyLinks_NodeId(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L384).
"""
HasAnyLinks(pinId::Ptr{PinId}) = lib.ax_NodeEditor_HasAnyLinks_PinId(pinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L385).
"""
BreakLinks(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_BreakLinks_NodeId(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L386).
"""
BreakLinks(pinId::Ptr{PinId}) = lib.ax_NodeEditor_BreakLinks_PinId(pinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L388).
"""
NavigateToContent(duration = -1) = lib.ax_NodeEditor_NavigateToContent(duration)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L389).
"""
NavigateToSelection(zoomIn = false, duration = -1) = lib.ax_NodeEditor_NavigateToSelection(zoomIn, duration)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L391).
"""
ShowNodeContextMenu(nodeId::Ptr{NodeId}) = lib.ax_NodeEditor_ShowNodeContextMenu(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L392).
"""
ShowPinContextMenu(pinId::Ptr{PinId}) = lib.ax_NodeEditor_ShowPinContextMenu(pinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L393).
"""
ShowLinkContextMenu(linkId) = lib.ax_NodeEditor_ShowLinkContextMenu(linkId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L394).
"""
ShowBackgroundContextMenu() = lib.ax_NodeEditor_ShowBackgroundContextMenu()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L396).
"""
EnableShortcuts(enable) = lib.ax_NodeEditor_EnableShortcuts(enable)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L397).
"""
AreShortcutsEnabled() = lib.ax_NodeEditor_AreShortcutsEnabled()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L399).
"""
BeginShortcut() = lib.ax_NodeEditor_BeginShortcut()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L400).
"""
AcceptCut() = lib.ax_NodeEditor_AcceptCut()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L401).
"""
AcceptCopy() = lib.ax_NodeEditor_AcceptCopy()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L402).
"""
AcceptPaste() = lib.ax_NodeEditor_AcceptPaste()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L403).
"""
AcceptDuplicate() = lib.ax_NodeEditor_AcceptDuplicate()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L404).
"""
AcceptCreateNode() = lib.ax_NodeEditor_AcceptCreateNode()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L405).
"""
GetActionContextSize() = lib.ax_NodeEditor_GetActionContextSize()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L406).
"""
GetActionContextNodes(nodes::Ptr{NodeId}, size) = lib.ax_NodeEditor_GetActionContextNodes(nodes, size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L407).
"""
GetActionContextLinks(links, size) = lib.ax_NodeEditor_GetActionContextLinks(links, size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L408).
"""
EndShortcut() = lib.ax_NodeEditor_EndShortcut()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L410).
"""
GetCurrentZoom() = lib.ax_NodeEditor_GetCurrentZoom()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L412).
"""
GetHoveredNode() = lib.ax_NodeEditor_GetHoveredNode()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L413).
"""
GetHoveredPin() = lib.ax_NodeEditor_GetHoveredPin()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L414).
"""
GetHoveredLink() = lib.ax_NodeEditor_GetHoveredLink()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L415).
"""
GetDoubleClickedNode() = lib.ax_NodeEditor_GetDoubleClickedNode()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L416).
"""
GetDoubleClickedPin() = lib.ax_NodeEditor_GetDoubleClickedPin()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L417).
"""
GetDoubleClickedLink() = lib.ax_NodeEditor_GetDoubleClickedLink()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L418).
"""
IsBackgroundClicked() = lib.ax_NodeEditor_IsBackgroundClicked()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L419).
"""
IsBackgroundDoubleClicked() = lib.ax_NodeEditor_IsBackgroundDoubleClicked()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L420).
"""
GetBackgroundClickButtonIndex() = lib.ax_NodeEditor_GetBackgroundClickButtonIndex()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L421).
"""
GetBackgroundDoubleClickButtonIndex() = lib.ax_NodeEditor_GetBackgroundDoubleClickButtonIndex()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L423).
"""
GetLinkPins(linkId, startPinId::Ptr{PinId}, endPinId::Ptr{PinId}) =
    lib.ax_NodeEditor_GetLinkPins(linkId, startPinId, endPinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L425).
"""
PinHadAnyLinks(pinId::Ptr{PinId}) = lib.ax_NodeEditor_PinHadAnyLinks(pinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L427).
"""
GetScreenSize() = lib.ax_NodeEditor_GetScreenSize()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L428).
"""
ScreenToCanvas(pos::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_ScreenToCanvas(pos)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L429).
"""
CanvasToScreen(pos::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_CanvasToScreen(pos)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L431).
"""
GetNodeCount() = lib.ax_NodeEditor_GetNodeCount()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L432).
"""
GetOrderedNodeIds(nodes::Ptr{NodeId}, size) = lib.ax_NodeEditor_GetOrderedNodeIds(nodes, size)

@static if VERSION >= v"1.11"
    eval(
        Meta.parse(
            "public Destroy, SetCurrentEditor, GetCurrentEditor, CreateEditor, DestroyEditor, GetConfig, GetStyle, GetStyleColorName, PushStyleColor, PopStyleColor, PushStyleVar, PopStyleVar, Begin, End, BeginNode, BeginPin, PinRect, PinPivotRect, PinPivotSize, PinPivotScale, PinPivotAlignment, EndPin, Group, EndNode, BeginGroupHint, GetGroupMin, GetGroupMax, GetHintForegroundDrawList, GetHintBackgroundDrawList, EndGroupHint, GetNodeBackgroundDrawList, Link, Flow, BeginCreate, QueryNewLink, QueryNewNode, AcceptNewItem, RejectNewItem, EndCreate, BeginDelete, QueryDeletedLink, QueryDeletedNode, AcceptDeletedItem, RejectDeletedItem, EndDelete, SetNodePosition, SetGroupSize, GetNodePosition, GetNodeSize, CenterNodeOnScreen, SetNodeZPosition, GetNodeZPosition, RestoreNodeState, Suspend, Resume, IsSuspended, IsActive, HasSelectionChanged, GetSelectedObjectCount, GetSelectedNodes, GetSelectedLinks, IsNodeSelected, IsLinkSelected, ClearSelection, SelectNode, SelectLink, DeselectNode, DeselectLink, DeleteNode, DeleteLink, HasAnyLinks, BreakLinks, NavigateToContent, NavigateToSelection, ShowNodeContextMenu, ShowPinContextMenu, ShowLinkContextMenu, ShowBackgroundContextMenu, EnableShortcuts, AreShortcutsEnabled, BeginShortcut, AcceptCut, AcceptCopy, AcceptPaste, AcceptDuplicate, AcceptCreateNode, GetActionContextSize, GetActionContextNodes, GetActionContextLinks, EndShortcut, GetCurrentZoom, GetHoveredNode, GetHoveredPin, GetHoveredLink, GetDoubleClickedNode, GetDoubleClickedPin, GetDoubleClickedLink, IsBackgroundClicked, IsBackgroundDoubleClicked, GetBackgroundClickButtonIndex, GetBackgroundDoubleClickButtonIndex, GetLinkPins, PinHadAnyLinks, GetScreenSize, ScreenToCanvas, CanvasToScreen, GetNodeCount, GetOrderedNodeIds, NodeId, value, PinId, LinkId",
        ),
    )
end
