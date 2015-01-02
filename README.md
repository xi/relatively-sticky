# Relatively Sticky

This is work in progress.

*relatively sticky* is planned to be a drop-in replacement for the excellent
[sticky-kit](https://github.com/leafo/sticky-kit). The idea was to be able to
have sticky elements within any scrollable element, not only window. But from
the simple idea this grew into a rewrite of more or less the whole project.

The approach taken here is different from the one in sticky-kit: Instead of
using a mixture of static, absolute and fixed positioning for different cases
(normal, bottomed, fixed) this always uses relative positioning. This way the
element stays in its original context and we do not need to sync it manually.
There is also no need for a spacer.

License: WTFPL
