require 'json'

module Commissioner
  
  def initialize(type, x = 0, y = 0, options = {})
    eval %W{
      Shapes::#{type.capitalize}.new(x, y, options)
    }
  end
  
  class Shapes    
    module Raphael
      
      OPTIONS = {
        
      }
      
      def type
        self.class.downcase
      end

      def normalize(x_array = @x, y_array = @y)
        new_values = {}
        
        [x_array, y_array].each_with_index do |array, i|
          max = array.max
          min = array.min
          range = max - min

          array.each do |value|
            length = i == 0 ? value - min : max - value
            fraction = length / range
            new_values[i] = fraction.to_f
          end
        end
        
        clone = self.clone
        clone.x, clone.y = new_values[0], new_values[1]
        return clone
      end

      def normalize!(x_array = @x, y_array = @y)
        clone = normalize(x_array, y_array)
        self.x, self.y = clone.x, clone.y
      end

      def normalize_to(context)
        x_array = context.x
        y_array = context.y
        normalize(x_array, y_array)
      end

      def normalize_to!(context)
        clone = normalize_to(context)
        self.x, self.y = clone.x, clone.y
      end
    end

    class Path
      include Raphael
      attr_accessor :x, :y, :path_string, :color, :stroke, :stroke_width

      def initialize(x_array = [], y_array = [], options = {})
        context = options[:context] || nil
        stroke = options[:color] || 'black'
        stroke_width = options[:stroke_width] || 1
        @x = [x_array].flatten
        @y = [y_array].flatten

        if context
          normalize_to!(context)
        elsif options[:normalize] == true
          normalize!
        end
        
        @path_string = create_path_string
      end

      def create_path_string(x_array = self.x, y_array = self.y)
        string = ''
        [x_array].flatten.each_with_index do |value, i|
          command = i == 0 ? 'M' : 'L'
          string << [command, value, y_array[i]].join(' ')
        end
        return string
      end
      
      def commission
        attributes = {
          :type => self.type,
          :path_string => self.path_string
        }
      end
    end

    class Circle
      include Raphael
      attr_accessor :x, :y, :radius, :stroke, :stroke_width

      def initialize(x = 0, y = 0, radius = 0, options = {})
        @x = x
        @y = y
        @radius = radius
        
        stroke = options[:stroke] || 'black'
        stroke_width = options[:stroke_width] || 1
        context = options[:context]
        
        if context
          normalize_to!(context)
        elsif options[:normalize] == true
          normalize!
        end
      end
    end

    class Text
      include Raphael
      attr_accessor :x, :y, :text

      def initialize(x = 0, y = 0, text = '')
        if context
          normalize_to!(context)
        elsif options[:normalize] == true
          normalize!
        end
      end
    end
  end

  class Graph
    
  end
  
  module Helpers
    
  end
end