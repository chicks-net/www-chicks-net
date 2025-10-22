+++
title = "SankeyMATIC File Format"
date = 2025-10-21
draft = false
+++

## What is SankeyMATIC?

SankeyMATIC is a web-based tool that creates Sankey diagrams—visual representations
showing flows and proportional relationships between sources and targets. Think of
it like a visual flow chart where the thickness of each connection represents the
magnitude of what's flowing through it.

## Basic Syntax

The format is dead simple: `Source [Number] Target`

Here's a real example:

```text
Income [100] Checking Account
```

That line creates a flow from "Income" to "Checking Account" with a value of 100.

## File Format Rules

- One flow per line in the Inputs field
- Node names are case-sensitive (so 'Revenue' and 'revenue' are different nodes)
- Use the same node name across multiple lines to create multiple flows in/out
- Click "Preview" after entering your data to generate the diagram
- Node names can be nearly anything, including emoji (but can't look like amounts `[123]` or colors `#abc`)
- Blank lines and lines starting with `//` are ignored (great for comments and organizing your data)

## Quick Example

```text
A [8] C
B [4] C
```

This creates two flows into node C—one from A with value 8, and one from B with value 4.

## Working with Spreadsheet Data

Got your data organized in columns? Here's the deal. If you've got three columns
(From, To, Amount), you can use a formula to rearrange them into SankeyMATIC format.

In Excel or Google Sheets, use either:

```text
=A2 & " [" & C2 & "] " & B2
```

or the more verbose:

```text
=CONCATENATE(A2, " [", C2, "] ", B2)
```

Copy the resulting values and paste them straight into SankeyMATIC's Inputs field.

## Advanced Syntax

### Amount Formats

Amounts can be integers or decimals: `[17]` or `[209247.2712]`. Don't use commas
or unit indicators—just the raw numbers.

### Calculated Flows

Sometimes you don't know the exact amount, or you want SankeyMATIC to figure it out
for you:

- `[*]` — consumes all excess from the source node
- `[?]` — provides whatever's missing to the target node

These work just like regular flows and can have colors and opacity too.

### Comments

Start any line with `//` to make it a comment:

```text
// Revenue sources
Income [5000] Checking
Bonus [1000] Checking

// Expenses
Checking [2000] Rent
Checking [500] Food
```

## Working with Colors

### Node Colors

You can assign colors to individual nodes using node declarations that start with a colon:

```text
:NodeName #ColorCode
```

For example:

```text
:Revenue #006600
:Expenses #CC0000
```

Colors use standard hex format: `#rgb` or `#rrggbb` (like `#3cf` or `#009A00`).
Case doesn't matter.

### Flow Colors

Add a color right to the end of any flow line:

```text
Source [Amount] Target #ColorCode
```

Real example:

```text
Income [5000] Checking #00CC00
```

### Color Inheritance

Here's where it gets interesting. You can tell nodes to pass their color along to
their flows:

```text
:NodeName #ColorCode >>     // flows FROM this node inherit its color
:NodeName #ColorCode <<     // flows TO this node inherit its color
:NodeName #ColorCode << >>  // flows both ways inherit its color
```

Example:

```text
:Revenue #00AA00 >>
Revenue [5000] Checking
Revenue [1000] Savings
```

Both flows from Revenue will be green.

### Opacity Control

Make flows more or less transparent by adding a decimal after the color (0.0 to 0.9999):

```text
Income [5000] Checking #00CC00.8
```

Higher numbers = more opaque (brighter), lower numbers = more transparent. Default
flow opacity is 0.45, which is why flows look lighter than nodes.

### Color Themes

SankeyMATIC comes with four built-in themes you can pick from:

- **Categories** — 10 colors
- **Tableau10** — 10 colors (based on Tableau's palette)
- **Dark** — 8 colors
- **Varied** — 12 colors

These are based on D3.js color scales and you can rotate them to start from any
color in the sequence.

### Color Precedence

When there's a conflict, here's the order SankeyMATIC uses:

For flows:

1. Explicit flow color (what you specified on the flow line)
2. Source node inheritance (`>>`)
3. Target node inheritance (`<<`)
4. Default setting

For nodes:

1. Explicit definition (`:NodeName #Color`)
2. Default theme assignment

## Customization Options

### Diagram Dimensions

You can adjust width and height to match your data—go tall, wide, or square depending
on what looks best for your particular flow.

### Node Spacing

This one's important. Around 50% spacing typically works well. Too little and your
diagram looks crowded. Too much and your flows get so thin you can't tell the
differences anymore.

## Features

- Automatic node layout (it figures out where to put everything)
- Proportional flow thickness (bigger numbers = thicker flows)
- Multiple customization options for labels, units, and colors
- Export capabilities
- Advanced scaling options
- Imbalance detection (it'll warn you if things don't add up)

## Tips from Experience

Node spacing makes or breaks your diagram's readability. Start with 50% and tweak
from there based on how complex your data is. The goal is making it easy to compare
flow magnitudes at a glance.

## More Information

For the complete manual with all the bells and whistles, check out:

- [SankeyMATIC manual](https://sankeymatic.com/manual/) — Main documentation
- [Syntax reference](https://sankeymatic.com/manual/syntax.html) — Detailed syntax guide
- [Colors reference](https://sankeymatic.com/manual/colors.html) — Color system documentation
