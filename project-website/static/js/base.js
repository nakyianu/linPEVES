/* Animate in any elements:
    @PARAMS:
        * parent: the parent element to append the elements to
        * elements: an HTMLElement which is the wrapper for the elements to be displayed
*/
async function displayElements(parent, elements) {
    if (parent != null) {
        parent.appendChild(elements);
    }
    for (let i = 0; i < elements.children.length; i++) {
        animateOpacity(elements.children[i], i * 100);
    }
}

// Animate the opacity of an element:
function animateOpacity(element, delay) {
    element.style.opacity = 0;
    element.style.transition = "opacity 1s";
    setTimeout(() => {
        element.style.opacity = 1;
    }, delay);
}

// Add an event listener for the [Enter] key:
function submitListener(elem, fn) {
    elem.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') fn();
    });
}