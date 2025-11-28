// meta.cue - Validation schema for .fini/meta.toml
// This schema defines the structure and constraints for repository metadata

// The repo section contains repository URLs and identifiers
repo: {
	// HTTPS URL for the repository (must be a valid GitHub HTTPS URL)
	"repo-url": string & =~"^https://github\\.com/[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+$"

	// SSH URL for the repository (must be a valid GitHub SSH URL)
	"repo-ssh": string & =~"^git@github\\.com:[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+\\.git$"
}
