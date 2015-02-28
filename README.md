# Relatively Sticky

*relatively sticky* is a drop-in replacement for the excellent
[sticky-kit](https://github.com/leafo/sticky-kit). The idea was to be able to
have sticky elements within any scrollable element, not only `window`. But from
the simple idea this grew into a rewrite of more or less the whole project.

License: WTFPL

## Usage

    $("#sticky_item").stick_in_parent()

You can optionally pass a hash of options to configure how Relativly Sitcky
works. The following options are accepted, each one is optional:

`parent`
:   The element will be the parent of the sticky item. The dimensions of the
    parent control when the sticky element bottoms out. Defaults to the closest
    parent of the sticky element. Can be a selector.

`scrollable`
:   The element in which the sticky item should stick. Defaults to `window`.
    Can be a selector.

`sticky_class`
:   The name of the CSS class to apply to elements when they have become stuck.
    Defaults to `"is_stuck"`.

`offset_top`
:   offsets the initial sticking position by of number of pixels, can be either
    negative or positive

`bottoming`
:   Boolean to control whether elements bottom out. Defaults to `true`

## quick reminder of the "traditional" positioning algorithms

static
:   This is the "normal" positioning algorithm. `top`, `right`, `bottom` and
    `left` will have no effect.

relative
:   Works mostly like `static`, but the element will be displayed with the
    specified offset relative to its original position. All other elements will
    still behave as if there was no offset.

absolute
:   The element will be displayed with the specified offset relative to the
    next parent with a non-static positioning. All other elements will behave
    as if this element did not exist.

fixed
:   The element will be displayed with the specified offset relative to the
    window. All other elements will behave as if this element did not exist.


## some notes on sticky positioning

Sticky positioning today is a commonly used feature in web development. For
example, there is the `affix` class in
[twitter bootstrap](http://getbootstrap.com/javascript/#affix), a jquery plugin
called [sticky-kit](https://github.com/leafo/sticky-kit) and there is even an
effort to include it in the
[CSS standard](http://dev.w3.org/csswg/css-position-3/#position-property).

The idea is that an element is displayed in normal flow as long as it is on the
screen. But when you scroll, instead of leaving the screen, it "sticks" to it.
This is especially usefull for navigation elements which need to be available
all the time.

So `sticky` works like `static` by default and like `fixed` when it sticks to
the screen. But that is `fixed` with a bit of `relative` because all other
elements must still behave as if the sticky element would still be at its
original position.

Now there are two approaches how sticky can be implemented if it is not
available natively. The first approach is to use `fixed`. In that case you need
to create a "spacer" element that will sit at the original position of the
sticky element in order to make all other elements behave correctly.

The second approach is to use relative positioning. In that scenario, the
position of the sticky element needs to be recalculated on every scroll event.

Most libraries (all I could find) use the first approach, probably because it
has better performance. But there might be cases where the second approach is
more suitable, for example scrollable child elements or fluid design. So this
library implements exactly that.

## Conclusion

-   Use native sticky positioning where possible (AFAIK Firefox and Safari).
-   Evaluate which approach works best for you in your specific usecase.  Most
    likely, *sticky-kit* is the better choice. But maybe *relatively-sticky*
    actually works better for you.

Example:

    var stick = function(element, modernizr, top) {
        if (modernizr.csspositionsticky) {
            element.css({
                position: 'sticky',
                top: top + 'px'
            });
        } else {
            element.stick_in_parent({
                offset_top: top
            });
        }
    };
