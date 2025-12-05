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
                    // Make the cell clickable with proper accessibility
                    cell.style.cursor = 'pointer';
                    cell.style.userSelect = 'none';
                    cell.title = 'Click to copy';
                    cell.classList.add('emoji-shortcode');

                    // Add ARIA attributes for screen readers
                    cell.setAttribute('role', 'button');
                    cell.setAttribute('tabindex', '0');
                    cell.setAttribute('aria-label', `Copy emoji shortcode ${text} to clipboard`);

                    // Add live region for status announcements
                    const liveRegion = document.createElement('span');
                    liveRegion.setAttribute('aria-live', 'polite');
                    liveRegion.setAttribute('aria-atomic', 'true');
                    liveRegion.className = 'sr-only';
                    cell.appendChild(liveRegion);

                    // Copy function
                    const copyToClipboard = function() {
                        const shortcode = this.textContent.trim().replace('✓ Copied!', '').trim();

                        // Copy to clipboard
                        navigator.clipboard.writeText(shortcode).then(() => {
                            // Visual and screen reader feedback
                            const originalText = this.textContent;
                            const originalBg = this.style.backgroundColor;
                            const originalAriaLabel = this.getAttribute('aria-label');

                            this.textContent = '✓ Copied!';
                            this.style.backgroundColor = '#90EE90';
                            this.setAttribute('aria-label', `${shortcode} copied to clipboard`);

                            // Announce to screen readers
                            const liveRegion = this.querySelector('.sr-only');
                            if (liveRegion) {
                                liveRegion.textContent = `${shortcode} copied to clipboard`;
                            }

                            // Reset after 1.5 seconds
                            setTimeout(() => {
                                this.textContent = originalText;
                                this.style.backgroundColor = originalBg;
                                this.setAttribute('aria-label', originalAriaLabel);
                                if (liveRegion) {
                                    liveRegion.textContent = '';
                                }
                            }, 1500);
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
                                const originalText = this.textContent;
                                const originalBg = this.style.backgroundColor;
                                const originalAriaLabel = this.getAttribute('aria-label');

                                this.textContent = '✓ Copied!';
                                this.style.backgroundColor = '#90EE90';
                                this.setAttribute('aria-label', `${shortcode} copied to clipboard`);

                                const liveRegion = this.querySelector('.sr-only');
                                if (liveRegion) {
                                    liveRegion.textContent = `${shortcode} copied to clipboard`;
                                }

                                setTimeout(() => {
                                    this.textContent = originalText;
                                    this.style.backgroundColor = originalBg;
                                    this.setAttribute('aria-label', originalAriaLabel);
                                    if (liveRegion) {
                                        liveRegion.textContent = '';
                                    }
                                }, 1500);
                            } catch (err) {
                                console.error('Fallback copy failed:', err);
                                const liveRegion = this.querySelector('.sr-only');
                                if (liveRegion) {
                                    liveRegion.textContent = 'Failed to copy to clipboard';
                                }
                            }
                            document.body.removeChild(textarea);
                        });
                    };

                    // Add click handler
                    cell.addEventListener('click', copyToClipboard);

                    // Add keyboard support (Enter and Space)
                    cell.addEventListener('keydown', function(e) {
                        if (e.key === 'Enter' || e.key === ' ') {
                            e.preventDefault();
                            copyToClipboard.call(this);
                        }
                    });
                }
            });
        });
    });

    // Add CSS for hover effect and accessibility
    const style = document.createElement('style');
    style.textContent = `
        .emoji-shortcode:hover {
            background-color: #f0f0f0;
            transition: background-color 0.2s;
        }

        .emoji-shortcode:focus {
            outline: 2px solid #0066cc;
            outline-offset: 2px;
            background-color: #f0f0f0;
        }

        .emoji-shortcode {
            border-radius: 3px;
            padding: 2px 4px;
        }

        /* Screen reader only - visually hidden but accessible */
        .sr-only {
            position: absolute;
            width: 1px;
            height: 1px;
            padding: 0;
            margin: -1px;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            white-space: nowrap;
            border: 0;
        }
    `;
    document.head.appendChild(style);
});
