// Emoji and Shortcode Copy to Clipboard
// Makes emoji characters and shortcodes clickable and copies them to clipboard

document.addEventListener('DOMContentLoaded', function() {
    // Constants
    const FEEDBACK_TIMEOUT_MS = 1500;
    const SUCCESS_COLOR = '#90EE90';

    // Only run on the emoji reference page
    if (!window.location.pathname.includes('/reference/emoji')) {
        return;
    }

    // Helper function to show copy feedback (success or error)
    function showCopyFeedback(element, textToCopy, isSuccess = true) {
        const originalText = element.textContent;
        const originalBg = element.style.backgroundColor;
        const originalAriaLabel = element.getAttribute('aria-label');

        if (isSuccess) {
            element.textContent = '✓ Copied!';
            element.style.backgroundColor = SUCCESS_COLOR;
            element.setAttribute('aria-label', `${textToCopy} copied to clipboard`);
        }

        const liveRegion = element.querySelector('.sr-only');
        if (liveRegion) {
            liveRegion.textContent = isSuccess
                ? `${textToCopy} copied to clipboard`
                : 'Failed to copy to clipboard';
        }

        if (isSuccess) {
            setTimeout(() => {
                element.textContent = originalText;
                element.style.backgroundColor = originalBg;
                element.setAttribute('aria-label', originalAriaLabel);
                if (liveRegion) {
                    liveRegion.textContent = '';
                }
            }, FEEDBACK_TIMEOUT_MS);
        }
    }

    // Helper function to create a copy-to-clipboard handler
    function createCopyHandler(cell, textToCopy, itemDescription) {
        return function() {
            // Copy to clipboard
            navigator.clipboard.writeText(textToCopy).then(() => {
                showCopyFeedback(this, textToCopy, true);
            }).catch(err => {
                console.error('Failed to copy:', err);
                // Fallback for older browsers
                const textarea = document.createElement('textarea');
                textarea.value = textToCopy;
                textarea.style.position = 'fixed';
                textarea.style.opacity = '0';
                document.body.appendChild(textarea);
                textarea.select();
                try {
                    document.execCommand('copy');
                    showCopyFeedback(this, textToCopy, true);
                } catch (err) {
                    console.error('Fallback copy failed:', err);
                    showCopyFeedback(this, textToCopy, false);
                }
                document.body.removeChild(textarea);
            });
        };
    }

    // Helper function to make a cell clickable
    function makeClickable(cell, textToCopy, className, ariaLabel, tooltip) {
        // Store the text to copy in a data attribute
        cell.dataset.copyText = textToCopy;

        // Make the cell clickable with proper accessibility
        cell.style.cursor = 'pointer';
        cell.style.userSelect = 'none';
        cell.title = tooltip;
        cell.classList.add(className);

        // Add ARIA attributes for screen readers
        cell.setAttribute('role', 'button');
        cell.setAttribute('tabindex', '0');
        cell.setAttribute('aria-label', ariaLabel);

        // Add live region for status announcements
        const liveRegion = document.createElement('span');
        liveRegion.setAttribute('aria-live', 'polite');
        liveRegion.setAttribute('aria-atomic', 'true');
        liveRegion.className = 'sr-only';
        cell.appendChild(liveRegion);

        // Create copy handler
        const copyToClipboard = createCopyHandler(cell, textToCopy);

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

    // Find all table cells that contain emoji characters or shortcodes
    const tables = document.querySelectorAll('table');

    tables.forEach(table => {
        // Get all rows in the table body
        const rows = table.querySelectorAll('tbody tr');

        rows.forEach(row => {
            const cells = row.querySelectorAll('td');

            // Process emoji cell (first column, index 0)
            if (cells.length > 0) {
                const emojiCell = cells[0];
                const emojiText = emojiCell.textContent.trim();

                // Check if cell contains an emoji (Unicode emoji ranges)
                // This regex covers most common emoji ranges
                const emojiRegex = /[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F000}-\u{1F02F}\u{1F0A0}-\u{1F0FF}\u{1F100}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F900}-\u{1F9FF}]/u;
                if (emojiText && emojiRegex.test(emojiText)) {
                    makeClickable(
                        emojiCell,
                        emojiText,
                        'emoji-character',
                        `Copy emoji ${emojiText} to clipboard`,
                        'Click to copy emoji'
                    );
                }
            }

            // Process shortcode cells (look through all cells for shortcode pattern)
            cells.forEach(cell => {
                const text = cell.textContent.trim();

                // Match shortcode pattern - more permissive to catch all variants
                const shortcodeMatch = text.match(/^:[a-zA-Z0-9_+-]+:$/);

                if (shortcodeMatch) {
                    makeClickable(
                        cell,
                        text,
                        'emoji-shortcode',
                        `Copy emoji shortcode ${text} to clipboard`,
                        'Click to copy shortcode'
                    );
                }
            });
        });
    });

    // Add CSS for hover effect and accessibility
    const style = document.createElement('style');
    style.textContent = `
        .emoji-character:hover,
        .emoji-shortcode:hover {
            background-color: #f0f0f0;
            transition: background-color 0.2s;
        }

        .emoji-character:focus,
        .emoji-shortcode:focus {
            outline: 2px solid #0066cc;
            outline-offset: 2px;
            background-color: #f0f0f0;
        }

        .emoji-character,
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
