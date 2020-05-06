# frozen_string_literal: true

# Utility Functions
module Utils
  def text_box(x, y, default_value)
    @x = x
    @y = y
    @default_value = default_value
  end

  def keyboard
    $gtk.args.inputs.keyboard
  end

  def mouse
    $gtk.args.inputs.mouse
  end

  def state
    $gtk.args.state
end

  def keyboard
    $gtk.args.inputs.keyboard
  end
end
