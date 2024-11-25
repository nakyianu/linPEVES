class NavBar extends HTMLElement {
    constructor() {
        super();
    }

    connectedCallback() {
        this.innerHTML = `
        <nav class="navbar">
            <a id="index" href="./index.html"> <img src="../static/img/peves.svg"></a>
            <a id="project" class='nav-item' href="./project.html">Project </a>
            <a id="about" class='nav-item' href="./about.html">About </a>
            <a id="github" class='nav-item' href="https://github.com/nakyianu/linPEVES" target="_blank">GitHub <i class="fa fa-external-link" style="font-size:16px"></i></a>
            
        </nav>`;
    }
}

customElements.define('nav-bar', NavBar);