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

using Plots
plot(rand(10))
savefig("myplot.svg") # hide
nothing # hide

# ![](myplot.svg)
