RAILS_ENV = 'test'

# Load full environment
require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))


# Returns true if the string +input+ contains certain tags, whose innerHTML
# each equals a certain value (allowing for surrouding whitespace). The tags
# and values are specified in +tag_hash+ (format: <tt>{:tagname1 => 'inner
# content', :tagname2 => 'inner content 2'}</tt>).
#
# Usage:
#   assert_tag_contents {:textarea => 'innerHTML'}, '<textarea id="foo"> innerHTML </textarea>'  # => true
def assert_tag_innerHTML(tag_hash, input)
  tag_hash.each_pair do |tag, innerHTML|
    tag = tag.to_s
    message = build_message '', "? tag with innerHTML containing ? is not present in input:\n?", tag, innerHTML, input
    assert_block message do
      input =~ /<#{tag}.*?>\s*?#{innerHTML}\s*?<\/#{tag}>/m
    end
  end
end


# Returns true if the string +input+ contains certain tags, whose innerHTML
# each contains a certain value. The tags and values are specified in +tag_hash+
# (format: <tt>{:tagname1 => 'inner content', :tagname2 => 'inner content 2'}</tt>).
#
# Usage:
#   assert_tag_contains {:textarea => 'innerHTML'}, '<textarea id="foo"> This is innerHTML </textarea>'  # => true
def assert_tag_contains(tag_hash, input)
  tag_hash.each_pair do |tag, innerHTML|
    tag = tag.to_s
    message = build_message '', "? tag with innerHTML containing ? is not present in input:\n?", tag, innerHTML, input
    assert_block message do
      input =~ /<#{tag}.*?>.*?#{innerHTML}.*?<\/#{tag}>/m
    end
  end
end