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

ENV["GKSwstype"] = "100" # hide
using GR
plot(rand(10), rand(10))
savefig("myplot.svg"); # hide

# ![](myplot.svg)
