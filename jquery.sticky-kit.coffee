###*
@license Sticky-kit v1.1.1 | WTFPL | Leaf Corcoran 2014 | http://leafo.net
###

$ = @jQuery or window.jQuery

win = $ window

# get top offset relative to any other element
#
# this function has the the following properties:
#
# -  top(a, b) == -top(b, a)
# -  top(a, b) + top(a, c) == top(a, c)
top = (element, context) ->
  if context == document
    if element == document
      return 0
    else if element == win
      return win.scrollTop()
    else
      return element.offset().top
  else
    return top(element, document) - top(context, document)


$.fn.stick_in_parent = (opts={}) ->
  {
    sticky_class
    parent: parent_selector
    scrollable: scrollable_selector
    offset_top
    bottoming: enable_bottoming
  } = opts

  offset_top ?= 0
  parent_selector ?= undefined
  sticky_class ?= "is_stuck"

  enable_bottoming = true unless enable_bottoming?

  for elm in @
    ((elm, detached, fixed, bottomed) ->
      return if elm.data "sticky_kit"
      elm.data "sticky_kit", true

      scrollable = win
      scrollable = elm.parent().closest(scrollable_selector) if scrollable_selector?
      throw "failed to find stick scrollable" unless scrollable.length

      parent = elm.parent()
      parent = parent.closest(parent_selector) if parent_selector?
      throw "failed to find stick parent" unless parent.length

      _top = 0

      elm.css "position", "relative"

      get_max = ->
        #           | +--------------+
        #           | |    border    |
        #  original | +--------------+
        #    top    | |   padding    |
        #           | +--------------+
        #           | |              |
        #           v |              |
        #         |   |+------------+|
        #         |   ||  original  ||
        #   top   |   ||  element   ||
        # maximum |   |+------------+|
        #         |   |              |
        #         |   |    parent    |
        #         |   |              |
        #         v   |              |
        #             |+------------+|
        #             ||   actual   ||
        #             ||  element   ||
        #             |+------------+|
        #             +--------------+
        #             |   padding    |
        #             +--------------+
        #             |    border    |
        #             +--------------+

        padding_bottom = parseInt parent.css("padding-bottom"), 10
        border_bottom = parseInt parent.css("border-bottom-width"), 10
        margin_top = parseInt elm.css("margin-top"), 10

        return parent.outerHeight() - (elm.outerHeight(true) - margin_top) - padding_bottom - border_bottom

      tick = ->
        return if detached

        fixed_old = fixed
        bottomed_old = bottomed

        margin_top = parseInt elm.css("margin-top"), 10
        original_top = top(elm, parent) - _top

        _top = top(scrollable, parent) + offset_top + margin_top
        if enable_bottoming
          max = get_max()
          _top = max if bottomed = _top >= max
        _top = Math.max(_top - original_top, 0)

        elm.css "top", _top

        if (fixed = _top != 0)
            elm.addClass(sticky_class)
        else
            elm.removeClass(sticky_class)

        # trigger events
        if !fixed && fixed_old
          elm.trigger("sticky_kit:unstick")
        if !bottomed && bottomed_old
          elm.trigger("sticky_kit:unbottom")
        if fixed && !fixed_old
          elm.trigger("sticky_kit:stick")
        else if bottomed && !bottomed_old
          elm.trigger("sticky_kit:bottom")

      detach = ->
        detached = true
        win.off "touchmove", tick
        win.off "scroll", tick
        win.off "resize", tick
        if scrollable_selector
          scrollable.off "touchmove", tick
          scrollable.off "scroll", tick
          elm.parentsUntil(scrollable).off "touchmove", tick
          elm.parentsUntil(scrollable).off "scroll", tick

        $(document.body).off "sticky_kit:recalc", tick
        elm.off "sticky_kit:detach", detach
        elm.removeData "sticky_kit"

        elm.css {
          position: ""
          top: ""
        }

        if fixed
          elm.removeClass sticky_class

      win.on "touchmove", tick
      win.on "scroll", tick
      win.on "resize", tick
      if scrollable_selector
        scrollable.on "touchmove", tick
        scrollable.on "scroll", tick
        elm.parentsUntil(scrollable).on "touchmove", tick
        elm.parentsUntil(scrollable).on "scroll", tick
      $(document.body).on "sticky_kit:recalc", tick
      elm.on "sticky_kit:detach", detach

      setTimeout tick, 0

    ) $ elm
  @
