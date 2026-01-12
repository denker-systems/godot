#pragma once

#include <godot_cpp/classes/node.hpp>

namespace godot {

class ExampleNode : public Node {
	GDCLASS(ExampleNode, Node)

private:
	double time_passed = 0.0;

protected:
	static void _bind_methods();

public:
	ExampleNode();
	~ExampleNode();

	void _process(double delta) override;
};

}
