const katexfonts = [
    "KaTeX_AMS-Regular",
    "KaTeX_Caligraphic-Bold",
    "KaTeX_Caligraphic-Regular",
    "KaTeX_Fraktur-Bold",
    "KaTeX_Fraktur-Regular",
    "KaTeX_Main-Regular",
    "KaTeX_Main-Bold",
    "KaTeX_Main-Italic",
    "KaTeX_Main-BoldItalic",
    "KaTeX_Math-Regular",
    "KaTeX_Math-Italic",
    "KaTeX_Math-BoldItalic",
    "KaTeX_SansSerif-Bold",
    "KaTeX_SansSerif-Italic",
    "KaTeX_SansSerif-Regular",
    "KaTeX_Script-Regular",
    "KaTeX_Size1-Regular",
    "KaTeX_Size2-Regular",
    "KaTeX_Size3-Regular",
    "KaTeX_Size4-Regular",
    "KaTeX_Typewriter-Regular",
]

const katexfonturl = "https://github.com/KaTeX/katex-fonts/raw/master/fonts/"

for font in katexfonts
    for ext in ["woff", "woff2"]
        fontname = join([font, ext], '.')
        fonturl = join([katexfonturl, fontname])
        dest = joinpath(_pkg_assets, "fonts", fontname)
        download(fonturl, dest)
    end
end
