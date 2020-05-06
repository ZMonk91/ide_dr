# frozen_string_literal: true

require '/app/components/sidebar.rb'
require '/app/components/utils.rb'

def mouse
  $gtk.args.inputs.mouse
end

def state
  $gtk.args.state
end

def keyboard
  $gtk.args.inputs.keyboard
end

# @my_sprite = [376, 310, 128, 101, 'dragonruby.png'].sprite

def tick(args)
  @bg = [0, 0, 1800, 1800, 50, 80, 90]
  primitives << @bg.solid
  # @time = Time.now.to_i
  
  state.object_list << @my_sprite
  args.outputs.primitives << @my_sprite

  init_state if state.tick_count == 0
  render_overlay

  state.game_args = args.gtk.args
  state.keyboard_pressed_at ||= state.tick_count
  puts state.my_obj
end
state.object_list = []
state.my_obj = @my_sprite
def render_overlay
  left_bar = Sidebar.new

  properties_container = Container.new(20, 500, 190, 3, 'Object Type Properties')
  prop_name = ValueBox.new('Name', 'default', properties_container, 1)
  prop_type = ValueBox.new('Type', 'Sprite', properties_container, 2)
  prop_test = ValueBox.new('Test', 'Other Value', properties_container, 3)

  general_container = Container.new(20, 320, 190, 5, 'General')
  general_layer = ValueBox.new('Layer', 'default', general_container, 1)
  general_angle = ValueBox.new('Angle', '0', general_container, 2)
  general_opacity = ValueBox.new('Alpha', '255', general_container, 3)
  general_position = ValueBox.new('Position', '255,255', general_container, 4)
  general_size = ValueBox.new('Size', '50,50', general_container, 5)

  primitives << left_bar.render
  primitives << properties_container.render
  prop_name.render
  prop_type.render
  prop_test.render

  primitives << general_container.render
  general_layer.render
  general_angle.render
  general_opacity.render
  general_position.render
  general_size.render
  blinking_caret
  text_edit_controls if state.editing_text == true
end

def show_edit_cursor
  $gtk.hide_cursor
  primitives << { x: mouse.x - 5, y: mouse.y, w: 15, h: 15, path: '/app/components/sprites/text_edit.png', a: 255 }.sprite
end

def hide_edit_cursor
  $gtk.show_cursor
end

def hovered(x, y, w, h)
  if mouse.x.between?(x, x + w) && mouse.y.between?(y, y + h)
    true
  else
    false
  end
end

state.object_text = ''
state.editing_object = nil
state.edited_text = ''
state.blinking_caret_enabled = false
state.blinking_caret_x = 0
state.blinking_caret_y = 0

def blinking_caret
  if state.tick_count % 60 < 30 && state.blinking_caret_enabled
    primitives << [state.blinking_caret_x, state.blinking_caret_y, '|', -5, 0, 255, 255, 255].label
  end
end

def mouse
  $gtk.args.inputs.mouse
end

def text_edit_controls
  text_length = state.current_editing_attr[0]
  letter_size = state.current_editing_attr[1]
  x_pos = state.current_editing_attr[2]
  container_x = state.current_editing_attr[3]
  if keyboard.right && (state.keyboard_pressed_at.elapsed? 10)
    state.keyboard_pressed_at = state.tick_count
    unless state.blinking_caret_x >= x_pos + ((text_length - 1) * letter_size)
      state.blinking_caret_x += letter_size
      end
    puts state.object_text[((state.blinking_caret_x - container_x) / letter_size).round]
  elsif keyboard.left && (state.keyboard_pressed_at.elapsed? 10)
    state.keyboard_pressed_at = state.tick_count
    state.blinking_caret_x -= letter_size unless state.blinking_caret_x <= x_pos
  elsif keyboard.backspace && (state.keyboard_pressed_at.elapsed? 10)
    puts "deleted #{state.object_text[((state.blinking_caret_x - container_x) / letter_size).round - 1]}"
    state.edited_text = 'nice'
  end
end

def init_state
  state.text_boxes ||= []
end

def primitives
  $gtk.args.primitives
end

def create_obj(id)
  state.obj[:id] = [0, 1, 2, 3, 'test']
  state.created_sprites << id
end


def object_defaults
state.obj_name
end