# # Header
# This is markdown: here's an equation $\frac{1}{2}$

2 + 2

# --
#
# A fragment
#
# ---
#
# # Here's a way to add plots

using Plots; gr()
plot(rand(10))
savefig("statplot.svg");

# ![](statplot.svg)
