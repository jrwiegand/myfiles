// Preferences
Phoenix.set({
    daemon: true,
    openAtLogin: true,
});

// Fractions
const ONE_EIGHTH = 1 / 8;
const ONE_QUARTER = 1 / 4;
const ONE_THIRD = 1 / 3;
const ONE_HALF = 1 / 2;

// Key Combinations
const CONTROL_SHIFT = ['control', 'shift'];
const CONTROL_OPTION_COMMAND = ['control', 'option', 'command'];

// Relative Directions
const LEFT = 'left';
const RIGHT = 'right';
const UP = 'up';
const DOWN = 'down';
const CENTER = 'center';
const FULL = 'full';

// Cardinal Directions
const NW = 'nw';
const NE = 'ne';
const SE = 'se';
const SW = 'sw';

class LocalWindow {
    constructor(window) {
        this.window = window;
        this.frame = window.frame();
        this.parent = window.screen().flippedVisibleFrame();
    }

    // Set frame
    set() {
        const { window, frame } = this;
        window.setFrame(frame);
        this.frame = window.frame();
        return this;
    }

    move(placement) {
        const { frame, parent } = this;
        const topBar = parent.y;
        let newFrame = {
            height: parent.height,
            width: parent.width,
            x: parent.x,
            y: parent.y
        }

        if (placement === LEFT) {
            newFrame.width = parent.width * ONE_HALF;
        } else if (placement === RIGHT) {
            newFrame.width = parent.width * ONE_HALF;
            newFrame.x = parent.width * ONE_HALF;
        } else if (placement === UP) {
            newFrame.height = parent.height * ONE_HALF;
        } else if (placement === DOWN) {
            newFrame.height = parent.height * ONE_HALF;
            newFrame.y = (parent.height * ONE_HALF) + topBar;
        } else if (placement === NW) {
            newFrame.height = parent.height * ONE_HALF;
            newFrame.width = parent.width * ONE_HALF;
        } else if (placement === NE) {
            newFrame.height = parent.height * ONE_HALF;
            newFrame.width = parent.width * ONE_HALF;
            newFrame.x = parent.width * ONE_HALF;
        } else if (placement === SW) {
            newFrame.height = parent.height * ONE_HALF;
            newFrame.width = parent.width * ONE_HALF;
            newFrame.y = (parent.height * ONE_HALF) + topBar;
        } else if (placement === SE) {
            newFrame.height = parent.height * ONE_HALF;
            newFrame.width = parent.width * ONE_HALF;
            newFrame.x = parent.width * ONE_HALF;
            newFrame.y = (parent.height * ONE_HALF) + topBar;
        } else if (placement === CENTER) {
            newFrame.height = parent.height * ONE_QUARTER * 3;
            newFrame.width = parent.width * ONE_QUARTER * 3;
            newFrame.x = parent.width * ONE_EIGHTH;
            newFrame.y = (parent.height * ONE_EIGHTH) + topBar;
        }

        if (this.hasChange(newFrame)) {
            frame.height = newFrame.height;
            frame.width = newFrame.width;
            frame.x = newFrame.x;
            frame.y = newFrame.y;
        }

        return this;
    }

    hasChange(newFrame) {
        const { frame } = this;
        return newFrame.height !== frame.height ||
            newFrame.width !== frame.width ||
            newFrame.x !== frame.x ||
            newFrame.y !== frame.y;
    }
}

// Window prototypes
Window.prototype.move = function (placement) {
    const window = new LocalWindow(this);
    window.move(placement).set();
};

// Key Bindings
Key.on(LEFT, CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.move(LEFT);
    }
});

Key.on(RIGHT, CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.move(RIGHT);
    }
});

Key.on(UP, CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.move(UP);
    }
});

Key.on(DOWN, CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.move(DOWN);
    }
});

Key.on('i', CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.move(NW);
    }
});

Key.on('o', CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.move(NE);
    }
});

Key.on('k', CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.move(SW);
    }
});

Key.on('l', CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.move(SE);
    }
});

Key.on('return', CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.maximize();
    }
});

Key.on('delete', CONTROL_OPTION_COMMAND, () => {
    const window = Window.focused();
    if (window) {
        window.move(CENTER);
    }
});
