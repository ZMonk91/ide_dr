# frozen_string_literal: true

module Libs
  attr_accessor :color_lib

  def color_lib
    {
      bg: [28, 28, 39],
      container: [40, 41, 61],
      primary_text: [250, 250, 250],
      secondary_text: [138, 139, 159],
      accent: [80, 122, 209]
    }
  end
end
