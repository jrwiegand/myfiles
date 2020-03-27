Phoenix.set({
    daemon: true,
    openAtLogin: true,
});

// constants
const combos = {
    two: ['control', 'shift'],
    three: ['control', 'option', 'command']
};

const orientations = {
    both: 'both',
    horizontal: 'horizontal',
    vertical: 'vertical',
};

const directions = {
    center: 'center',
    full: 'full',
    ne: 'ne',
    nw: 'nw',
    se: 'se',
    sw: 'sw',
};

const sizes = {
    eighth: 1 / 8,
    quarter: 1 / 4,
    third: 1 / 3,
    half: 1 / 2,
};

let cache = [];

// prototypes
Window.prototype.setWindowFrame = function (location) {
    const parent = this.screen().flippedVisibleFrame();
    const id = this.hash();
    let sizeIndex = 0;
    let newFrame = {
        y: null,
        x: null,
        width: null,
        height: null,
    };

    let lastLocation = cache.find((window) => {
        return this.hash() === window.id;
    });

    if (lastLocation && ++lastLocation.sizeIndex < location.sizes.length) {
        sizeIndex = lastLocation.sizeIndex;
    }

    let item = {
        id: id,
        sizeIndex: sizeIndex,
        orientation: location.orientation,
        point: location.point,
    };

    cache = cache.filter((window) => {
        return window.id !== id;
    });

    cache.push(item);

    const size = location.sizes[sizeIndex];

    switch (location.orientation) {
        case orientations.vertical:
            newFrame.width = Math.floor(parent.width * size);
            newFrame.height = parent.height;
            break;
        case orientations.horizontal:
            newFrame.width = parent.width;
            newFrame.height = Math.floor(parent.height * size);
            break;
        case orientations.both:
            newFrame.width = Math.floor(parent.width * size);
            newFrame.height = Math.floor(parent.height * size);
            break;
        default:
            newFrame.width = parent.width;
            newFrame.height = parent.height;
            break;
    }

    switch (location.point) {
        case directions.nw:
            newFrame.y = parent.y;
            newFrame.x = parent.x;
            break;
        case directions.ne:
            newFrame.y = parent.y;
            newFrame.x = parent.width - newFrame.width;
            break;
        case directions.sw:
            newFrame.y = parent.y + parent.height - newFrame.height;
            newFrame.x = parent.x;
            break;
        case directions.se:
            newFrame.y = parent.y + parent.height - newFrame.height;
            newFrame.x = parent.width - newFrame.width;
            break;
        case directions.center:
            newFrame.y = parent.y + Math.floor(parent.height * sizes.eighth);
            newFrame.x = Math.floor(parent.width * sizes.eighth);
            break;
        default:
            newFrame.y = parent.y;
            newFrame.x = parent.x;
            break;
    }

    this.setFrame(Object.assign(this.frame(), newFrame));
};

// bindings
Key.on('left', combos.three, () => {
    const window = Window.focused();
    if (window) {
        window.setWindowFrame({
            orientation: orientations.vertical,
            point: directions.nw,
            sizes: [sizes.half, sizes.third, sizes.third * 2]
        });
    }
});

Key.on('right', combos.three, () => {
    const window = Window.focused();
    if (window) {
        window.setWindowFrame({
            orientation: orientations.vertical,
            point: directions.ne,
            sizes: [sizes.half, sizes.third, sizes.third * 2]
        });
    }
});

Key.on('up', combos.three, () => {
    const window = Window.focused();
    if (window) {
        window.setWindowFrame({
            orientation: orientations.horizontal,
            point: directions.nw,
            sizes: [sizes.half, sizes.third, sizes.third * 2]
        });
    }
});

Key.on('down', combos.three, () => {
    const window = Window.focused();
    if (window) {
        window.setWindowFrame({
            orientation: orientations.horizontal,
            point: directions.sw,
            sizes: [sizes.half, sizes.third, sizes.third * 2]
        });
    }
});

Key.on('i', combos.three, () => {
    const window = Window.focused();
    if (window) {
        window.setWindowFrame({
            orientation: orientations.both,
            point: directions.nw,
            sizes: [sizes.half]
        });
    }
});

Key.on('o', combos.three, () => {
    const window = Window.focused();
    if (window) {
        window.setWindowFrame({
            orientation: orientations.both,
            point: directions.ne,
            sizes: [sizes.half]
        });
    }
});

Key.on('k', combos.three, () => {
    const window = Window.focused();
    if (window) {
        window.setWindowFrame({
            orientation: orientations.both,
            point: directions.sw,
            sizes: [sizes.half]
        });
    }
});

Key.on('l', combos.three, () => {
    const window = Window.focused();
    if (window) {
        window.setWindowFrame({
            orientation: orientations.both,
            point: directions.se,
            sizes: [sizes.half]
        });
    }
});

Key.on('delete', combos.three, () => {
    const window = Window.focused();
    if (window) {
        window.setWindowFrame({
            orientation: orientations.both,
            point: directions.center,
            sizes: [sizes.quarter * 3]
        });
    }
});

Key.on('return', combos.three, () => {
    const window = Window.focused();
    if (window) {
        window.maximize();
    }
});
