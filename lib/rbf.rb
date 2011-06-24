#--
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                   Version 2, December 2004
#
#  Copyleft meh. [http://meh.paranoid.pk | meh@paranoici.org]
#
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'rbf/syntax'
require 'rbf/parser'
require 'rbf/transform'
require 'rbf/interpreter'

require 'parslet/convenience'

module RBF
  def self.parse (text, syntax=nil)
    Transform.new.apply(Parser.apply(syntax || Syntax::Default).new.parse_with_debug(text)) or
      raise SyntaxError, 'There is a syntax error'
  end

  def self.evaluate (text, options={})
    tree = text.is_a?(Array) ? text : parse(text.to_s, options[:syntax])

    Interpreter.new.evaluate(tree, options)
  end

  def self.execute (file, options={})
    evaluate(File.read(file), options)
  end
end
