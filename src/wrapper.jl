const PtrOrRef{T} = Union{Ptr{T},Ref{T}} where {T}
const VoidablePtrOrRef{T} = Union{Ptr{T},Ref{T},Ptr{Cvoid}} where {T}

const LinkId = lib.LinkId
const NodeId = lib.NodeId
const PinId = lib.PinId
const EditorContext = lib.EditorContext
const Config = lib.Config
const Style = lib.cimnodes_editor_Style

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
$(TYPEDSIGNATURES)

The returned `Config` is heap-allocated, it must be freed with [`Destroy`](@ref).

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L109).
"""
lib.Config() = lib.ax_NodeEditor_Config_Config_Config()

"""
Destructor for `Config`
"""
Destroy(self::Ptr{Config}) = lib.Config_destroy(self)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L287).
"""
SetCurrentEditor(ctx) = lib.ax_NodeEditor_SetCurrentEditor(ctx)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L288).
"""
GetCurrentEditor() = lib.ax_NodeEditor_GetCurrentEditor()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L289).
"""
CreateEditor(config = C_NULL) = lib.ax_NodeEditor_CreateEditor(config)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L290).
"""
DestroyEditor(ctx) = lib.ax_NodeEditor_DestroyEditor(ctx)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L291).
"""
GetConfig(ctx = C_NULL) = lib.ax_NodeEditor_GetConfig(ctx)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L293).
"""
GetStyle() = lib.ax_NodeEditor_GetStyle()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L294).
"""
GetStyleColorName(colorIndex) = lib.ax_NodeEditor_GetStyleColorName(colorIndex)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L296).
"""
PushStyleColor(colorIndex, color::Union{ImVec4,NTuple{4}}) = lib.ax_NodeEditor_PushStyleColor(colorIndex, color)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L297).
"""
PopStyleColor(count = 1) = lib.ax_NodeEditor_PopStyleColor(count)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L299).
"""
PushStyleVar(varIndex::StyleVar, value::Real) = lib.ax_NodeEditor_PushStyleVar_Float(varIndex, value)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L300).
"""
PushStyleVar(varIndex::StyleVar, value::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PushStyleVar_Vec2(varIndex, value)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L301).
"""
PushStyleVar(varIndex::StyleVar, value::Union{ImVec4,NTuple{4}}) = lib.ax_NodeEditor_PushStyleVar_Vec4(varIndex, value)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L302).
"""
PopStyleVar(count = 1) = lib.ax_NodeEditor_PopStyleVar(count)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L307).
"""
Begin(id, size::Union{ImVec2,NTuple{2}} = ImVec2(0, 0)) = lib.ax_NodeEditor_Begin(id, size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L308).
"""
End() = lib.ax_NodeEditor_End()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L310).
"""
BeginNode(id::NodeId) = lib.ax_NodeEditor_BeginNode(id)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L311).
"""
BeginPin(id::PinId, kind) = lib.ax_NodeEditor_BeginPin(id, kind)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L312).
"""
PinRect(a::Union{ImVec2,NTuple{2}}, b::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PinRect(a, b)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L313).
"""
PinPivotRect(a::Union{ImVec2,NTuple{2}}, b::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PinPivotRect(a, b)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L314).
"""
PinPivotSize(size::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PinPivotSize(size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L315).
"""
PinPivotScale(scale::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PinPivotScale(scale)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L316).
"""
PinPivotAlignment(alignment::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_PinPivotAlignment(alignment)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L317).
"""
EndPin() = lib.ax_NodeEditor_EndPin()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L318).
"""
Group(size::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_Group(size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L319).
"""
EndNode() = lib.ax_NodeEditor_EndNode()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L321).
"""
BeginGroupHint(nodeId::NodeId) = lib.ax_NodeEditor_BeginGroupHint(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L322).
"""
GetGroupMin() = lib.ax_NodeEditor_GetGroupMin()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L323).
"""
GetGroupMax() = lib.ax_NodeEditor_GetGroupMax()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L324).
"""
GetHintForegroundDrawList() = lib.ax_NodeEditor_GetHintForegroundDrawList()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L325).
"""
GetHintBackgroundDrawList() = lib.ax_NodeEditor_GetHintBackgroundDrawList()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L326).
"""
EndGroupHint() = lib.ax_NodeEditor_EndGroupHint()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L329).
"""
GetNodeBackgroundDrawList(nodeId::NodeId) = lib.ax_NodeEditor_GetNodeBackgroundDrawList(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L331).
"""
Link(id, startPinId::PinId, endPinId::PinId, color::Union{ImVec4,NTuple{4}} = ImVec4(1, 1, 1, 1), thickness = 1.0f0) =
    lib.ax_NodeEditor_Link(id, startPinId, endPinId, color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L333).
"""
Flow(linkId, direction = FlowDirection_Forward) = lib.ax_NodeEditor_Flow(linkId, direction)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L335).
"""
BeginCreate(color::Union{ImVec4,NTuple{4}} = ImVec4(1, 1, 1, 1), thickness = 1.0f0) =
    lib.ax_NodeEditor_BeginCreate(color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L337).
"""
QueryNewLink(startId::VoidablePtrOrRef{PinId}, endId::VoidablePtrOrRef{PinId}) =
    lib.ax_NodeEditor_QueryNewLink_Nil(startId, endId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L338).
"""
QueryNewLink(
    startId::VoidablePtrOrRef{PinId},
    endId::VoidablePtrOrRef{PinId},
    color::Union{ImVec4,NTuple{4}},
    thickness::Real = 1.0f0,
) = lib.ax_NodeEditor_QueryNewLink_Vec4(startId, endId, color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L339).
"""
QueryNewNode(pinId::VoidablePtrOrRef{PinId}) = lib.ax_NodeEditor_QueryNewNode_Nil(pinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L340).
"""
QueryNewNode(pinId::VoidablePtrOrRef{PinId}, color::Union{ImVec4,NTuple{4}}, thickness::Real = 1.0f0) =
    lib.ax_NodeEditor_QueryNewNode_Vec4(pinId, color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L341).
"""
AcceptNewItem() = lib.ax_NodeEditor_AcceptNewItem_Nil()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L342).
"""
AcceptNewItem(color::Union{ImVec4,NTuple{4}}, thickness::Real = 1.0f0) =
    lib.ax_NodeEditor_AcceptNewItem_Vec4(color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L343).
"""
RejectNewItem() = lib.ax_NodeEditor_RejectNewItem_Nil()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L344).
"""
RejectNewItem(color::Union{ImVec4,NTuple{4}}, thickness::Real = 1.0f0) =
    lib.ax_NodeEditor_RejectNewItem_Vec4(color, thickness)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L345).
"""
EndCreate() = lib.ax_NodeEditor_EndCreate()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L347).
"""
BeginDelete() = lib.ax_NodeEditor_BeginDelete()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L348).
"""
QueryDeletedLink(
    linkId::VoidablePtrOrRef{LinkId},
    startId::VoidablePtrOrRef{PinId} = C_NULL,
    endId::VoidablePtrOrRef{PinId} = C_NULL,
) = lib.ax_NodeEditor_QueryDeletedLink(linkId, startId, endId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L349).
"""
QueryDeletedNode(nodeId::VoidablePtrOrRef{NodeId}) = lib.ax_NodeEditor_QueryDeletedNode(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L350).
"""
AcceptDeletedItem(deleteDependencies = true) = lib.ax_NodeEditor_AcceptDeletedItem(deleteDependencies)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L351).
"""
RejectDeletedItem() = lib.ax_NodeEditor_RejectDeletedItem()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L352).
"""
EndDelete() = lib.ax_NodeEditor_EndDelete()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L354).
"""
SetNodePosition(nodeId::NodeId, editorPosition::Union{ImVec2,NTuple{2}}) =
    lib.ax_NodeEditor_SetNodePosition(nodeId, editorPosition)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L355).
"""
SetGroupSize(nodeId::NodeId, size::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_SetGroupSize(nodeId, size)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L356).
"""
GetNodePosition(nodeId::NodeId) = lib.ax_NodeEditor_GetNodePosition(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L357).
"""
GetNodeSize(nodeId::NodeId) = lib.ax_NodeEditor_GetNodeSize(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L358).
"""
CenterNodeOnScreen(nodeId::NodeId) = lib.ax_NodeEditor_CenterNodeOnScreen(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L359).
"""
SetNodeZPosition(nodeId::NodeId, z) = lib.ax_NodeEditor_SetNodeZPosition(nodeId, z)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L360).
"""
GetNodeZPosition(nodeId::NodeId) = lib.ax_NodeEditor_GetNodeZPosition(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L362).
"""
RestoreNodeState(nodeId::NodeId) = lib.ax_NodeEditor_RestoreNodeState(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L364).
"""
Suspend() = lib.ax_NodeEditor_Suspend()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L365).
"""
Resume() = lib.ax_NodeEditor_Resume()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L366).
"""
IsSuspended() = lib.ax_NodeEditor_IsSuspended()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L368).
"""
IsActive() = lib.ax_NodeEditor_IsActive()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L370).
"""
HasSelectionChanged() = lib.ax_NodeEditor_HasSelectionChanged()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L371).
"""
GetSelectedObjectCount() = lib.ax_NodeEditor_GetSelectedObjectCount()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L372).

`ids` is resized to fit and returned.
"""
function GetSelectedNodes!(ids::Vector{NodeId})
    resize!(ids, lib.ax_NodeEditor_GetSelectedNodes(C_NULL, 0))
    lib.ax_NodeEditor_GetSelectedNodes(ids, length(ids))
    return ids
end

"""
$(TYPEDSIGNATURES)

Allocating variant of [`GetSelectedNodes!`](@ref).
"""
GetSelectedNodes() = GetSelectedNodes!(NodeId[])

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L373).

`ids` is resized to fit and returned.
"""
function GetSelectedLinks!(ids::Vector{LinkId})
    resize!(ids, lib.ax_NodeEditor_GetSelectedLinks(C_NULL, 0))
    lib.ax_NodeEditor_GetSelectedLinks(ids, length(ids))
    return ids
end

"""
$(TYPEDSIGNATURES)

Allocating variant of [`GetSelectedLinks!`](@ref).
"""
GetSelectedLinks() = GetSelectedLinks!(LinkId[])

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L374).
"""
IsNodeSelected(nodeId::NodeId) = lib.ax_NodeEditor_IsNodeSelected(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L375).
"""
IsLinkSelected(linkId) = lib.ax_NodeEditor_IsLinkSelected(linkId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L376).
"""
ClearSelection() = lib.ax_NodeEditor_ClearSelection()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L377).
"""
SelectNode(nodeId::NodeId, append = false) = lib.ax_NodeEditor_SelectNode(nodeId, append)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L378).
"""
SelectLink(linkId, append = false) = lib.ax_NodeEditor_SelectLink(linkId, append)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L379).
"""
DeselectNode(nodeId::NodeId) = lib.ax_NodeEditor_DeselectNode(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L380).
"""
DeselectLink(linkId) = lib.ax_NodeEditor_DeselectLink(linkId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L382).
"""
DeleteNode(nodeId::NodeId) = lib.ax_NodeEditor_DeleteNode(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L383).
"""
DeleteLink(linkId) = lib.ax_NodeEditor_DeleteLink(linkId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L385).
"""
HasAnyLinks(nodeId::NodeId) = lib.ax_NodeEditor_HasAnyLinks_NodeId(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L386).
"""
HasAnyLinks(pinId::PinId) = lib.ax_NodeEditor_HasAnyLinks_PinId(pinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L387).
"""
BreakLinks(nodeId::NodeId) = lib.ax_NodeEditor_BreakLinks_NodeId(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L388).
"""
BreakLinks(pinId::PinId) = lib.ax_NodeEditor_BreakLinks_PinId(pinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L390).
"""
NavigateToContent(duration = -1) = lib.ax_NodeEditor_NavigateToContent(duration)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L391).
"""
NavigateToSelection(zoomIn = false, duration = -1) = lib.ax_NodeEditor_NavigateToSelection(zoomIn, duration)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L393).
"""
ShowNodeContextMenu(nodeId::VoidablePtrOrRef{NodeId}) = lib.ax_NodeEditor_ShowNodeContextMenu(nodeId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L394).
"""
ShowPinContextMenu(pinId::VoidablePtrOrRef{PinId}) = lib.ax_NodeEditor_ShowPinContextMenu(pinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L395).
"""
ShowLinkContextMenu(linkId::VoidablePtrOrRef{LinkId}) = lib.ax_NodeEditor_ShowLinkContextMenu(linkId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L396).
"""
ShowBackgroundContextMenu() = lib.ax_NodeEditor_ShowBackgroundContextMenu()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L398).
"""
EnableShortcuts(enable) = lib.ax_NodeEditor_EnableShortcuts(enable)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L399).
"""
AreShortcutsEnabled() = lib.ax_NodeEditor_AreShortcutsEnabled()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L401).
"""
BeginShortcut() = lib.ax_NodeEditor_BeginShortcut()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L402).
"""
AcceptCut() = lib.ax_NodeEditor_AcceptCut()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L403).
"""
AcceptCopy() = lib.ax_NodeEditor_AcceptCopy()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L404).
"""
AcceptPaste() = lib.ax_NodeEditor_AcceptPaste()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L405).
"""
AcceptDuplicate() = lib.ax_NodeEditor_AcceptDuplicate()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L406).
"""
AcceptCreateNode() = lib.ax_NodeEditor_AcceptCreateNode()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L407).
"""
GetActionContextSize() = lib.ax_NodeEditor_GetActionContextSize()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L408).

`ids` is resized to fit and returned.
"""
function GetActionContextNodes!(ids::Vector{NodeId})
    resize!(ids, lib.ax_NodeEditor_GetActionContextNodes(C_NULL, 0))
    lib.ax_NodeEditor_GetActionContextNodes(ids, length(ids))
    return ids
end

"""
$(TYPEDSIGNATURES)

Allocating variant of [`GetActionContextNodes!`](@ref).
"""
GetActionContextNodes() = GetActionContextNodes!(NodeId[])

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L409).

`ids` is resized to fit and returned.
"""
function GetActionContextLinks!(ids::Vector{LinkId})
    resize!(ids, lib.ax_NodeEditor_GetActionContextLinks(C_NULL, 0))
    lib.ax_NodeEditor_GetActionContextLinks(ids, length(ids))
    return ids
end

"""
$(TYPEDSIGNATURES)

Allocating variant of [`GetActionContextLinks!`](@ref).
"""
GetActionContextLinks() = GetActionContextLinks!(LinkId[])

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L410).
"""
EndShortcut() = lib.ax_NodeEditor_EndShortcut()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L412).
"""
GetCurrentZoom() = lib.ax_NodeEditor_GetCurrentZoom()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L414).
"""
GetHoveredNode() = lib.ax_NodeEditor_GetHoveredNode()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L415).
"""
GetHoveredPin() = lib.ax_NodeEditor_GetHoveredPin()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L416).
"""
GetHoveredLink() = lib.ax_NodeEditor_GetHoveredLink()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L417).
"""
GetDoubleClickedNode() = lib.ax_NodeEditor_GetDoubleClickedNode()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L418).
"""
GetDoubleClickedPin() = lib.ax_NodeEditor_GetDoubleClickedPin()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L419).
"""
GetDoubleClickedLink() = lib.ax_NodeEditor_GetDoubleClickedLink()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L420).
"""
IsBackgroundClicked() = lib.ax_NodeEditor_IsBackgroundClicked()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L421).
"""
IsBackgroundDoubleClicked() = lib.ax_NodeEditor_IsBackgroundDoubleClicked()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L422).
"""
GetBackgroundClickButtonIndex() = lib.ax_NodeEditor_GetBackgroundClickButtonIndex()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L423).
"""
GetBackgroundDoubleClickButtonIndex() = lib.ax_NodeEditor_GetBackgroundDoubleClickButtonIndex()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L425).
"""
GetLinkPins(linkId, startPinId::VoidablePtrOrRef{PinId}, endPinId::VoidablePtrOrRef{PinId}) =
    lib.ax_NodeEditor_GetLinkPins(linkId, startPinId, endPinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L427).
"""
PinHadAnyLinks(pinId::PinId) = lib.ax_NodeEditor_PinHadAnyLinks(pinId)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L429).
"""
GetScreenSize() = lib.ax_NodeEditor_GetScreenSize()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L430).
"""
ScreenToCanvas(pos::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_ScreenToCanvas(pos)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L431).
"""
CanvasToScreen(pos::Union{ImVec2,NTuple{2}}) = lib.ax_NodeEditor_CanvasToScreen(pos)

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L433).
"""
GetNodeCount() = lib.ax_NodeEditor_GetNodeCount()

"""
$(TYPEDSIGNATURES)

[Upstream link](https://github.com/thedmd/imgui-node-editor/blob/master/imgui_node_editor.h#L434).

`ids` is resized to fit and returned.
"""
function GetOrderedNodeIds!(ids::Vector{NodeId})
    resize!(ids, lib.ax_NodeEditor_GetNodeCount())
    lib.ax_NodeEditor_GetOrderedNodeIds(ids, length(ids))
    return ids
end

"""
$(TYPEDSIGNATURES)

Allocating variant of [`GetOrderedNodeIds!`](@ref).
"""
GetOrderedNodeIds() = GetOrderedNodeIds!(NodeId[])

"""
$(TYPEDSIGNATURES)
"""
lib.NodeId(val::Integer) = lib.ax_NodeEditor_NodeId(val)

"""
$(TYPEDSIGNATURES)
"""
lib.PinId(val::Integer) = lib.ax_NodeEditor_PinId(val)

"""
$(TYPEDSIGNATURES)
"""
lib.LinkId(val::Integer) = lib.ax_NodeEditor_LinkId(val)

"""
$(TYPEDSIGNATURES)
"""
Value(self::NodeId) = lib.ax_NodeEditor_NodeId_value(self)

"""
$(TYPEDSIGNATURES)
"""
Value(self::PinId) = lib.ax_NodeEditor_PinId_value(self)

"""
$(TYPEDSIGNATURES)
"""
Value(self::LinkId) = lib.ax_NodeEditor_LinkId_value(self)

@static if VERSION >= v"1.11"
    eval(
        Meta.parse(
            "public Destroy, SetCurrentEditor, GetCurrentEditor, CreateEditor, DestroyEditor, GetConfig, GetStyle, GetStyleColorName, PushStyleColor, PopStyleColor, PushStyleVar, PopStyleVar, Begin, End, BeginNode, BeginPin, PinRect, PinPivotRect, PinPivotSize, PinPivotScale, PinPivotAlignment, EndPin, Group, EndNode, BeginGroupHint, GetGroupMin, GetGroupMax, GetHintForegroundDrawList, GetHintBackgroundDrawList, EndGroupHint, GetNodeBackgroundDrawList, Link, Flow, BeginCreate, QueryNewLink, QueryNewNode, AcceptNewItem, RejectNewItem, EndCreate, BeginDelete, QueryDeletedLink, QueryDeletedNode, AcceptDeletedItem, RejectDeletedItem, EndDelete, SetNodePosition, SetGroupSize, GetNodePosition, GetNodeSize, CenterNodeOnScreen, SetNodeZPosition, GetNodeZPosition, RestoreNodeState, Suspend, Resume, IsSuspended, IsActive, HasSelectionChanged, GetSelectedObjectCount, GetSelectedNodes!, GetSelectedNodes, GetSelectedLinks!, GetSelectedLinks, IsNodeSelected, IsLinkSelected, ClearSelection, SelectNode, SelectLink, DeselectNode, DeselectLink, DeleteNode, DeleteLink, HasAnyLinks, BreakLinks, NavigateToContent, NavigateToSelection, ShowNodeContextMenu, ShowPinContextMenu, ShowLinkContextMenu, ShowBackgroundContextMenu, EnableShortcuts, AreShortcutsEnabled, BeginShortcut, AcceptCut, AcceptCopy, AcceptPaste, AcceptDuplicate, AcceptCreateNode, GetActionContextSize, GetActionContextNodes!, GetActionContextNodes, GetActionContextLinks!, GetActionContextLinks, EndShortcut, GetCurrentZoom, GetHoveredNode, GetHoveredPin, GetHoveredLink, GetDoubleClickedNode, GetDoubleClickedPin, GetDoubleClickedLink, IsBackgroundClicked, IsBackgroundDoubleClicked, GetBackgroundClickButtonIndex, GetBackgroundDoubleClickButtonIndex, GetLinkPins, PinHadAnyLinks, GetScreenSize, ScreenToCanvas, CanvasToScreen, GetNodeCount, GetOrderedNodeIds!, GetOrderedNodeIds, Value",
        ),
    )
end
