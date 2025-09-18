# Hugo Shortcodes

This directory contains custom Hugo shortcodes for the chicks.net site.

## Available Shortcodes

### github_repo

Displays a GitHub repository preview card similar to Slack's social preview. Automatically fetches repository metadata from the GitHub API.

#### Usage

```markdown
<!-- Minimal usage - fetches everything from GitHub API -->
{{< github_repo owner="microsoft" repo="vscode" >}}

<!-- Override specific values if needed -->
{{< github_repo owner="torvalds" repo="linux" description="Custom description" >}}
```

#### Parameters

- `owner` (required): GitHub username or organization
- `repo` (required): Repository name
- `description` (optional): Override the repository description
- `language` (optional): Override the primary language
- `stars` (optional): Override the star count
- `forks` (optional): Override the fork count

#### Features

- **Automatic API fetching**: Pulls stars, forks, description, and language from GitHub
- **Manual overrides**: Any parameter can be manually specified to override API data
- **Error handling**: Gracefully handles API failures without breaking the build
- **Number formatting**: Large numbers (1000+) display as "1k", "2k", etc.
- **Responsive design**: Adapts to the site's theme variables

#### Example Output

The shortcode generates a card with:

- Repository icon and title (linked to GitHub)
- Description
- Language with color indicator
- Star and fork counts with icons
- "github.com" footer

#### Styling

The shortcode includes embedded CSS that uses Hugo PaperMod theme variables:

- `--border`: Border colors
- `--theme`: Background colors
- `--primary`: Link colors
- `--secondary`: Secondary text colors

## Adding New Shortcodes

When adding new shortcodes:

1. Create the `.html` file in this directory
2. Follow Hugo shortcode conventions
3. Include error handling for required parameters
4. Use theme variables for consistent styling
5. Update this README with documentation
