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

using Plots; pyplot()
plot(rand(10))
savefig("statplot.png");

# ![](statplot.png)
