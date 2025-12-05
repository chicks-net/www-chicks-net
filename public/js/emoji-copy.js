// Emoji Shortcode Copy to Clipboard
// Makes emoji shortcodes clickable and copies them to clipboard

document.addEventListener('DOMContentLoaded', function() {
    // Only run on the emoji reference page
    if (!window.location.pathname.includes('/reference/emoji')) {
        return;
    }

    // Find all table cells that contain emoji shortcodes
    const tables = document.querySelectorAll('table');

    tables.forEach(table => {
        // Get all rows in the table body
        const rows = table.querySelectorAll('tbody tr');

        rows.forEach(row => {
            const cells = row.querySelectorAll('td');

            // Look for cells containing shortcode patterns (`:something:`)
            cells.forEach(cell => {
                const text = cell.textContent.trim();

                // Match shortcode pattern
                const shortcodeMatch = text.match(/^:[\w+-]+:$/);

                if (shortcodeMatch) {
                    // Make the cell clickable
                    cell.style.cursor = 'pointer';
                    cell.style.userSelect = 'none';
                    cell.title = 'Click to copy';
                    cell.classList.add('emoji-shortcode');

                    // Add click handler
                    cell.addEventListener('click', function() {
                        const shortcode = this.textContent.trim();

                        // Copy to clipboard
                        navigator.clipboard.writeText(shortcode).then(() => {
                            // Visual feedback
                            const originalText = this.textContent;
                            const originalBg = this.style.backgroundColor;

                            this.textContent = '✓ Copied!';
                            this.style.backgroundColor = '#90EE90';

                            // Reset after 1 second
                            setTimeout(() => {
                                this.textContent = originalText;
                                this.style.backgroundColor = originalBg;
                            }, 1000);
                        }).catch(err => {
                            console.error('Failed to copy:', err);
                            // Fallback for older browsers
                            const textarea = document.createElement('textarea');
                            textarea.value = shortcode;
                            textarea.style.position = 'fixed';
                            textarea.style.opacity = '0';
                            document.body.appendChild(textarea);
                            textarea.select();
                            try {
                                document.execCommand('copy');
                                this.textContent = '✓ Copied!';
                                this.style.backgroundColor = '#90EE90';
                                setTimeout(() => {
                                    this.textContent = originalText;
                                    this.style.backgroundColor = originalBg;
                                }, 1000);
                            } catch (err) {
                                console.error('Fallback copy failed:', err);
                            }
                            document.body.removeChild(textarea);
                        });
                    });
                }
            });
        });
    });

    // Add CSS for hover effect
    const style = document.createElement('style');
    style.textContent = `
        .emoji-shortcode:hover {
            background-color: #f0f0f0;
            transition: background-color 0.2s;
        }

        .emoji-shortcode {
            border-radius: 3px;
            padding: 2px 4px;
        }
    `;
    document.head.appendChild(style);
});
