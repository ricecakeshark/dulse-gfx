module dulse_gfx.graphics.resource_graph.resource_graph;

struct GfxResourceGraph
{
	GraphEdge[][] edge_list;
	GraphEdgeId[][] outgoing;
	GraphEdgeId[][] incoming;

	typeof(this) pass(uint index_1, uint index_2)
	{
		//edge_list[index_1][index_2] = GraphEdge(index_1, index_2);
		/+
		if(){
		outgoing ~= GraphEdgeId();
		}else{
		incoming ~= GraphEdgeId();
		}
		+/
		return this;
	}
}

struct GraphEdge
{
	GraphEdgeId from;
	GraphEdgeId to;

	this(uint from, uint to)
	{
		this.from = GraphEdgeId(from);
		this.to = GraphEdgeId(to);
	}
}

struct GraphNodeId
{
	uint index;
	uint generation;
}

struct GraphEdgeId
{
	uint index;
	uint generation;
}
