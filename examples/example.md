# Example presentation

Some Julia code

```julia
1+2
```

--

A fragment

---

# Some equations

Here is an inline fraction: $\frac{1}{2}$

And some identities in display mode:

$$e^{i\pi} + 1 = 0$$

$$\sum_{n=0}^\infty \alpha^n = \frac{1}{1-\alpha}$$

---

# A plot

```@example index
using Plots; gr()
Plots.plot(rand(10))
savefig("statplot.svg"); # hide
```

# ![](statplot.svg)
