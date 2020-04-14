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

using GR
plot(rand(10), rand(10))
savefig("myplot.svg"); # hide

# ![](myplot.svg)
