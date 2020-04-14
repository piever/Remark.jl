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
ENV["GKSwstype"] = "100" # hide
using GR
plot(rand(10), rand(10))
savefig("myplot.svg"); # hide
```

# ![](myplot.svg)
