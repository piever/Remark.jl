# Example presentation

Some Julia code

```julia
1+2
```

--

A fragment

---

# Some equations

Here is a fraction: $$\frac{1}{2}$$

---

# A plot

```@example index
using Plots; gr()
Plots.plot(rand(10))
savefig("statplot.svg");
```

# ![](statplot.svg)
