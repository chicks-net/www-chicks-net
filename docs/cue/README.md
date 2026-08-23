# CUE Validation Examples

This directory contains [CUE](https://cuelang.org/) schemas for validating configuration files in this project.

## What's CUE?

CUE is a powerful data validation language that helps catch configuration errors before they cause problems. Think of it as a type system for your config files - it validates structure, types, and constraints.

## Installation

If you don't have CUE installed yet:

```bash
# macOS
brew install cue

# Or download from https://cuelang.org/docs/install/
```

## Validating the Repository Metadata

The `repo-toml.cue` schema (in `docs/`) validates `.repo.toml` to ensure repository URLs and flags are correct and consistent.

### Basic Validation

```bash
# Validate .repo.toml against the schema
cue vet .repo.toml docs/repo-toml.cue
```

If everything's good, you'll get no output (silence is golden). If there's a problem, CUE will tell you exactly what's wrong.

### Viewing the Data

```bash
# See what CUE parsed from the TOML file
cue eval .repo.toml

# See the complete unified schema and data
cue eval docs/repo-toml.cue .repo.toml
```

## The Example Files

- `example1.cue` - Basic CUE syntax examples (numbers, lists, quoted fields)
- `example2.cue` - Shows constraint composition with the `&` operator

## Writing Your Own Schemas

CUE schemas define what's allowed in your config files:

```cue
// Simple field definitions
fieldName: string        // must be a string
count: int & >=0         // must be a non-negative integer

// Regex validation
email: =~"^[a-z]+@[a-z]+\\.[a-z]+$"

// Nested structures
server: {
    host: string
    port: int & >0 & <65536
}
```

## Learn More

- [CUE Language Specification](https://cuelang.org/docs/references/spec/)
- [CUE Tutorials](https://cuelang.org/docs/tutorials/)
- [CUE by Example](https://cuetorials.com/)
