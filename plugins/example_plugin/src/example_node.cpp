#include "example_node.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void ExampleNode::_bind_methods() {
}

ExampleNode::ExampleNode() {
	time_passed = 0.0;
}

ExampleNode::~ExampleNode() {
}

void ExampleNode::_process(double delta) {
	time_passed += delta;
	if ((int)time_passed % 5 == 0 && (int)(time_passed - delta) % 5 != 0) {
		UtilityFunctions::print("ExampleNode: 5 seconds passed");
	}
}
