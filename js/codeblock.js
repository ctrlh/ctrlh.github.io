// js/codeBlock.js

// Attach copy functionality to all code blocks with a .copy-btn inside.
function attachCopyButtons() {
  const codeBlocks = document.querySelectorAll('.code-block');
  codeBlocks.forEach((block) => {
    // Check if a copy button already exists
    if (block.querySelector('.copy-btn')) return;
    
    const copyButton = document.createElement('button');
    copyButton.classList.add('copy-btn');
    copyButton.textContent = 'Copy';
    copyButton.setAttribute('aria-label', 'Copy code');
    
    // When the button is clicked, copy the text content of the <code> element.
    copyButton.addEventListener('click', () => {
      const codeElement = block.querySelector('pre code');
      if (!codeElement) return;
      const codeText = codeElement.textContent;
      navigator.clipboard.writeText(codeText)
        .then(() => {
          copyButton.textContent = 'Copied!';
          setTimeout(() => { copyButton.textContent = 'Copy'; }, 2000);
        })
        .catch((err) => {
          console.error('Failed to copy code: ', err);
          copyButton.textContent = 'Error';
        });
    });
    
    // Append the button to the code block container.
    // Ensure the container is positioned relatively.
    block.style.position = 'relative';
    block.appendChild(copyButton);
  });
}

// Run this function after the DOM content is loaded or after you update code blocks.
document.addEventListener('DOMContentLoaded', attachCopyButtons);
