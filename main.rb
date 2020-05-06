# frozen_string_literal: true

require 'app/main_dev.rb' if $gtk.argv == './dragonruby --devmode'

def tick(args)
  args.outputs.labels << [480, 500, 'Old MAIN!']
  args.outputs.labels << [275, 150, '(Consider reading README.txt now.)']
  args.outputs.sprites << [376, 310, 128, 101, 'dragonruby.png']
  # puts $time
end
