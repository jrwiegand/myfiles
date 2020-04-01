Phoenix.set({
    daemon: true,
    openAtLogin: true,
});

// combinations
const CONTROL_OPTION = ['control', 'option'];
const CONTROL_OPTION_COMMAND = ['control', 'option', 'command'];

// orientations
const BOTH = 'both';
const HORIZONTAL = 'horizontal';
const VERTICAL = 'vertical';

// directions
const CENTER = 'center';
const FULL = 'full';
const NE = 'ne';
const NW = 'nw';
const SE = 'se';
const SW = 'sw';

// sizes
const QUARTER = 1 / 4;
const THIRD = 1 / 3;
const HALF = 1 / 2;

class MyWindow {
    constructor(window) {
        this.window = window;
        this.frame = window.frame();
        this.parent = window.screen().flippedVisibleFrame();
    }

    /**
     *  find the difference between the parent and the frame
     */
    difference() {
        return {
            x: this.parent.x - this.frame.x,
            y: this.parent.y - this.frame.y,
            width: this.parent.width - this.frame.width,
            height: this.parent.height - this.frame.height,
        };
    }

    /**
     * fill the window to the desire
     * @param {string} orientation
     * @param {number} size
     */
    fill(orientation) {
        switch (orientation) {
            case VERTICAL:
                this.frame.width = Math.floor(this.parent.width * HALF);
                this.frame.height = this.parent.height;
                break;
            case HORIZONTAL:
                this.frame.width = this.parent.width;
                this.frame.height = Math.floor(this.parent.height * HALF);
                break;
            case BOTH:
                this.frame.width = Math.floor(this.parent.width * HALF);
                this.frame.height = Math.floor(this.parent.height * HALF);
                break;
            case CENTER:
                this.frame.width = Math.floor(this.parent.width * QUARTER * 3);
                this.frame.height = Math.floor(this.parent.height * QUARTER * 3);
                break;
            default:
                this.frame.width = this.parent.width;
                this.frame.height = this.parent.height;
                break;
        }
        return this;
    }

    /**
     * fit the parent's screen
     */
    fit() {
        const difference = this.difference();
        if (difference.width < 0 || difference.height < 0) {
            this.maximize();
        }
        return this;
    }

    /**
     * halve the width of the frame
     */
    halve() {
        this.frame.width /= 2;
        return this;
    }

    /**
     * maximize to the parent's screen
     */
    maximize() {
        this.frame.width = this.parent.width;
        this.frame.height = this.parent.height;
        return this;
    }

    /**
     * resize SE-corner by factor
     * @param {Object} factor
     */
    resize(factor) {
        const difference = this.difference();
        let delta;
        if (factor.width) {
            delta = Math.min(this.parent.width * factor.width, difference.x + difference.width);
            this.frame.width += delta;
        } else if (factor.height) {
            delta = Math.min(
                this.parent.height * factor.height,
                difference.height - this.frame.y,
            );
            this.frame.height += delta;
        }
        return this;
    }

    /**
     * Move to screen
     * @param {string} screen
     */
    screen(screen) {
        this.parent = screen.flippedVisibleFrame();
        return this;
    }

    /**
     * Set frame
     */
    set() {
        this.window.setFrame(this.frame);
        this.frame = this.window.frame();
        return this;
    }

    /**
     * Move to cardinal directions NW, NE, SE, SW or relative direction CENTRE
     * @param {string} position
     */
    to(position) {
        const difference = this.difference();
        switch (position) {
            case NW:
                this.frame.y = this.parent.y;
                this.frame.x = this.parent.x;
                break;
            case NE:
                this.frame.y = this.parent.y;
                this.frame.x = difference.width;
                break;
            case SW:
                this.frame.y = this.parent.y + difference.height;
                this.frame.x = this.parent.x;
                break;
            case SE:
                this.frame.y = this.parent.y + difference.height;
                this.frame.x = difference.width;
                break;
            case CENTER:
                this.frame.y = this.parent.y + (difference.height * HALF);
                this.frame.x = difference.width * HALF;
                break;
            default:
                this.frame.y = this.parent.y;
                this.frame.x = this.parent.x;
                break;
        }
        return this;
    }
}

// Fill in screen
Window.prototype.fill = function (orientation) {
    this.chain().fill(orientation);
    return this.chain();
};

// Resize by factor
Window.prototype.resize = function (factor) {
    this.chain().resize(factor);
    return this.chain();
};

// set the frame
Window.prototype.set = function () {
    this.chain().set();
    return this.chain();
};

// To direction in screen
Window.prototype.to = function (position) {
    this.chain().to(position);
    return this.chain();
};

// bindings
Key.on('left', CONTROL_OPTION_COMMAND, () => {
    const window = new MyWindow(Window.focused());
    if (window) {
        window.fill(VERTICAL).to(NW).set();
    }
});

Key.on('right', CONTROL_OPTION_COMMAND, () => {
    const window = new MyWindow(Window.focused());
    if (window) {
        window.fill(VERTICAL).to(NE).set();
    }
});

Key.on('up', CONTROL_OPTION_COMMAND, () => {
    const window = new MyWindow(Window.focused());
    if (window) {
        window.fill(HORIZONTAL).to(NW).set();
    }
});

Key.on('down', CONTROL_OPTION_COMMAND, () => {
    const window = new MyWindow(Window.focused());
    if (window) {
        window.fill(HORIZONTAL).to(SW).set();
    }
});

Key.on('i', CONTROL_OPTION_COMMAND, () => {
    const window = new MyWindow(Window.focused());
    if (window) {
        window.fill(BOTH).to(NW).set();
    }
});

Key.on('o', CONTROL_OPTION_COMMAND, () => {
    const window = new MyWindow(Window.focused());
    if (window) {
        window.fill(BOTH).to(NE).set();
    }
});

Key.on('k', CONTROL_OPTION_COMMAND, () => {
    const window = new MyWindow(Window.focused());
    if (window) {
        window.fill(BOTH).to(SW).set();
    }
});

Key.on('l', CONTROL_OPTION_COMMAND, () => {
    const window = new MyWindow(Window.focused());
    if (window) {
        window.fill(BOTH).to(SE).set();
    }
});

Key.on('delete', CONTROL_OPTION_COMMAND, () => {
    const window = new MyWindow(Window.focused());
    if (window) {
        window.fill(CENTER).to(CENTER).set();
    }
});

Key.on('return', CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.maximize();
    }
});
