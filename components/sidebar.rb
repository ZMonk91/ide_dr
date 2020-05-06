# frozen_string_literal: true

require '/app/components/libs.rb'

class Sidebar
  include Libs
  def initialize
    @x = 0
    @y = 0
    @w = 220
    @h = 720
  end

  def render
    {
      x: @x,
      y: @y,
      w: @w,
      h: @h,
      r: color_lib[:bg][0],
      g: color_lib[:bg][1],
      b: color_lib[:bg][2]
    }.solid
  end
end

class Container
  include Libs
  attr_accessor :x, :y, :w, :h
  def initialize(x, y, w, num_of_inputs, title)
    @x = x
    @y = y
    @w = w
    @h = num_of_inputs * 30 + 5
    @title = title
  end

  def render
    primitives << [@x + 2, @y + @h + 20, @title, -3, 0, color_lib[:secondary_text]].label
    {
      x: @x,
      y: @y,
      h: @h,
      w: @w,
      r: color_lib[:container][0],
      g: color_lib[:container][1],
      b: color_lib[:container][2]
    }.solid
  end
end

class ValueBox
  include Utils
  include Libs
  def initialize(label, default_value, parent, iteration)
    @parent = parent
    @x = parent.x + 15,
         @y = parent.y + parent.h,
         @label = label,
         @iteration = iteration,
         @default_value = default_value,
         @v_x = parent.w + parent.x
  end

  def render
    label_box = {
      x: @parent.x + 5,
      y: @y - (25 * @iteration) - (5 * @iteration),
      w: @parent.w / 2 - 10,
      h: 25,
      r: color_lib[:container][0] - 5,
      g: color_lib[:container][1] - 5,
      b: color_lib[:container][2] - 5,
      a: 255
    }.solid

    label = {
      x: label_box.x + 5,
      y: label_box.y + (label_box.h - 5),
      text: @label,
      alignment_enum: 0,
      size_enum: -3,
      r: color_lib[:primary_text][0],
      g: color_lib[:primary_text][0],
      b: color_lib[:primary_text][0]
    }.label

    value_box = {
      x: @parent.x + label_box.w + 10,
      y: @y - (25 * @iteration) - (5 * @iteration),
      w: @parent.w / 2 - 10,
      h: 25,
      r: color_lib[:container][0] - 5,
      g: color_lib[:container][1] - 5,
      b: color_lib[:container][2] - 5,
      a: 255
    }.solid

    value = Textbox.new(
      x: value_box.x + 5,
      y: value_box.y + (value_box.h - 5),
      text: @default_value,
      alignment_enum: 0,
      size_enum: -3,
      r: color_lib[:primary_text][0],
      g: color_lib[:primary_text][0],
      b: color_lib[:primary_text][0],
      container: [value_box.x, value_box.y, value_box.w, value_box.h]
    )

    # Label
    ## Label BG
    primitives << label_box
    ## Label
    primitives << label
    # Value
    ## Value BG
    primitives << value_box
    primitives << value
    # Assign listener
    value.hover

    value.change_text(state.edited_text) if state.editing_object == value.id
    # end
  end
end

class Label
  attr_accessor :x, :y, :text, :hovered, :id, :size_enum, :container, :alignment_enum, :font, :r, :g, :b, :a

  def primitive_marker
    :label
  end
end

class Textbox < Label
  # constructor
  def initialize(x: 0, y: 0, text: 'def', r: 0, g: 0, b: 0, a: 255, alignment_enum: 0, size_enum: 0, container: [0, 0, 0, 0], **_args)
    self.id = object_id
    self.x = x
    self.y = y
    self.text = text
    self.r = r
    self.g = g
    self.b = b
    self.alignment_enum = alignment_enum
    self.size_enum = size_enum
    self.container = container
    @text_size = $gtk.calcstringbox(text, size_enum, 'font.ttf')
    state.editable_objects << self
  end

  def hover
    [mouse.x, mouse.y].inside_rect?(container) ? show_edit_cursor : hide_edit_cursor
    if [mouse.x, mouse.y].inside_rect?(container) && mouse.click
      letter_size = @text_size[0] / text.length
      nearest_letter = ((mouse.x - container.x) / letter_size).round
      state.editing_object = id
      state.editing_text = true
      state.current_editing_attr = [text.length, letter_size, x, container.x]
      state.blinking_caret_enabled = true

      if (nearest_letter * letter_size) > (text.length * letter_size)
        state.blinking_caret_x = x + ((text.length * letter_size) - 2)
      else
        state.blinking_caret_x = x + (nearest_letter * letter_size) - 2
      end
      state.blinking_caret_y = y
    end
  end

  def change_text(text)
    self.text = text
  end

  def mouse
    $gtk.args.inputs.mouse
  end
end
