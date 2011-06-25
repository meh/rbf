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
require 'rbf/optimizer'
require 'rbf/jit'
require 'rbf/interpreter'

module RBF
  def self.syntax (name)
    name.is_a?(Hash) ? name :
      (RBF::Syntax.const_get(name.to_s.capitalize) rescue nil) || Syntax::Default
  end

  def self.parse (text, syn=nil)
    Transform.new.apply(Parser.syntax(syntax(syn)).new.parse_with_debug(text)) or
      raise SyntaxError, 'There is a syntax error'
  end

  def self.optimize (text, options=nil)
    options ||= {}

    Optimizer.new(options).optimize(text.is_a?(Array) ? text : parse(text.to_s, options[:syntax]))
  end

  def self.evaluate (text, options=nil)
    options ||= {}

    Interpreter.new(options).evaluate(text)
  end

  def self.execute (file, options={})
    evaluate(File.read(file), options)
  end

  def self.[] (text, syn=nil)
    evaluate(text, :catch => true, :syntax => syn)
  end

  def self.repl (options=nil)
    require 'colorb'

    interpreter = Interpreter.new(options || {})

    loop do
      STDOUT.print '>> '.bold
      STDOUT.flush

      begin
        line = STDIN.gets.chomp rescue nil or raise SystemExit
      rescue Interrupt, SystemExit
        puts "\nExiting REPL."

        return false
      end

      begin
        if line.start_with?('!')
          case line[1 .. -1]
            when 'exit', 'quit'
              return true

            when 'storage'
              STDOUT.puts interpreter.storage.inspect

            when /^position(?:\s+(\d+))?$/
              if $1
                interpreter.storage.position = $1
              else
                STDOUT.puts interpreter.storage.position.to_s.bold
              end

            when /^get(?:\s+(\d+))?$/
              STDOUT.puts "#{($1 || interpreter.storage.position).to_s.bold}: #{interpreter.storage.get($1)}"

            when /^set(?:\s+(\d+)\s+(\d+))/
              interpreter.storage.set($2.to_i, $1.to_i)

            else
              STDOUT.puts 'Command not found or used improperly'.red
          end
        else
          interpreter.evaluate(line, interpreter.options.merge(:output => Class.new {
            attr_reader :last

            def print (text)
              STDOUT.print(text)

              @last = text[-1]
            end

            def flush
              STDOUT.sync
            end
          }.new))

          puts if interpreter.output.newline? && interpreter.output.last != "\n"
        end
      rescue SyntaxError
        next
      rescue
        STDOUT.puts $!.inspect.red, $@.join("\n")
      end
    end
  end
end
