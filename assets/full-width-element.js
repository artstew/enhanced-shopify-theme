if (!customElements.get('full-width-element')) {
  customElements.define('full-width-element', class fullWidthElement extends HTMLElement {
    constructor() {
      super();

      this.elementId = this.id;
      this.setScrollbarWidth();
      this.watchForResize();
    }

    setScrollbarWidth() {
      const scrollbarWidth = window.innerWidth - document.body.clientWidth;
    
      document.body.style.setProperty("--scrollbar-width", `${scrollbarWidth}px`);
    }

    watchForResize() {
      const resizeObserver = new ResizeObserver(entries => {
        for (let entry of entries) {
          if (entry.target.id === this.elementId) {
            this.setScrollbarWidth();
          }
        }
      });
      
      resizeObserver.observe(document.getElementById(this.elementId));
    }
  });
}
