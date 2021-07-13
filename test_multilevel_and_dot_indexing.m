clear

a = MCProp(5, 0.1);
a.get_coverage_interval(0.95)

b = [MCProp(5) MCProp(6) MCProp(7)];
b.Value
b(2:3).Value(1)
b([1 3]).Value(end)
b(2:3).Value