require 'helper'

context Commissioner do

  context '::Raphael' do

    context '::Path' do
      context 'creating a new Path' do
        setup { Commissioner::Shapes::Path.new( [0, 20, 40, 50], [10, 30, 60, 100] ) }
        asserts('creates an SVG string') { topic.create_path_string.is_a?(String) }
        asserts('properly assigns command') {topic.path_string == 'M 0 10L 20 30L 40 60L 50 100'}
        asserts('assigns attributes') { topic.x && topic.y && topic.path_string }
      end
    end
    
    context '::Circle' do
      context 'creating a new cirlce' do
        setup { Commissioner::Shapes::Circle.new(50, 60, 5) }
        asserts('assigns attribtues') { topic.x && topic.y && topic.radius }
      end
    end
    
    context '::Text' do
      context 'creating new text' do
        
      end
    end
  end

end