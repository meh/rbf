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

module RBF

module Syntax
  Default = {
    :forward  => '>',
    :backward => '<',

    :increase => '+',
    :decrease => '-',

    :output => '.',
    :input  => ',',

    :while_start => '[',
    :while_end   => ']'
  }

  Nintendo = {
    :forward  => '!!!!',
    :backward => 'ASD',

    :increase => 'XD',
    :decrease => 'LOL',

    :output => 'PLS',
    :input  => 'CMQ',

    :while_start => '[',
    :while_end   => ']'
  }

  Trollscript = {
    :forward  => 'ooo',
    :backward => 'ool',

    :increase => 'olo',
    :decrease => 'oll',

    :output => 'loo',
    :input  => 'lol',

    :while_start => 'llo',
    :while_end   => 'lll'
  }
end

end
