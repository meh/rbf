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
  def self.parse (text, keys=Syntax::Default)
    Transform.new.apply(Parser.apply(keys).new.parse_with_debug(text)) or
      raise SyntaxError, 'There is a syntax error'
  end

  def self.evaluate (text, keys=Syntax::Default)
    tree = text.is_a?(Array) ? text : parse(text.to_s, keys)

    Interpreter.new.evaluate(tree)
  end

  def self.execute (file, keys=Syntax::Default)
    evaluate(File.read(file), keys)
  end
end
