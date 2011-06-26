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

module Readline
  Commands = ['!exit', '!quit', '!storage', '!position', '!get', '!set', '!clear', '!reset']

  def self.supported?
    require 'colorb'
    require 'readline'

    true
  rescue Exception => e
    false
  end

  if supported?
    self.completion_proc = proc {|s|
      next unless s.start_with?('!')

      Commands.grep(/^#{Regexp.escape(s)}/)
    }
  end

  def self.readline_with_hist_management
    begin
      line = Readline.readline('>> '.bold, true)
    rescue Exception => e
      return
    end

    return unless line

    if line =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == line
      Readline::HISTORY.pop
    end

    line
  end
end

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
    begin
      require 'colorb'
      require 'readline'
    rescue LoadError
      warn 'You need colorb and readline to use the REPL, install them.'

      return false
    end

    interpreter = Interpreter.new(options || {})

    while line = Readline.readline_with_hist_management
      line.rstrip!

      if line.start_with?('!')
        case line[1 .. -1]
          when 'exit', 'quit'
            break

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

          when 'clear'
            interpreter.storage.clear!

          when 'reset'
            interpreter.storage.reset!

          else
            STDOUT.puts 'Command not found or used improperly'.red
        end

        next
      end

      begin
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

        puts if interpreter.output.last && interpreter.output.last != "\n"
      rescue SyntaxError
        next
      rescue
        STDOUT.puts $!.inspect.red, $@.join("\n")
      end
    end
    
    puts "\nExiting REPL."
  end
end
