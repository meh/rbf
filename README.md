RBF - Ruby BrainFuck
====================

Yay, birthday, dragon book, let's code.

With this thingy you can parse and evaluate brainfuck and brainfuck-like languages,
you can define your own syntax (aka aliases) to use as a brainfuck language.


This is the default syntax:

```ruby
{ 
  :forward  => '>',
  :backward => '<',

  :increase => '+',
  :decrease => '-',

  :output => '.',
  :input  => ',',

  :while_start => '[',
  :while_end   => ']' 
}
```

And this is a custom syntax:

```ruby
{ 
  :forward  => '!!!!',
  :backward => 'ASD',

  :increase => 'XD',
  :decrease => 'LOL',

  :output => 'PLS',
  :input  => 'CMQ',

  :while_start => '[',
  :while_end   => ']' 
}
```

Examples
--------

```ruby
require 'rbf'

RBF.parse('++[.]')                              # => ["+", "+", ["."]]
RBF.parse('XD XD [PLS]', RBF::Syntax::Nintendo) # => ["+", "+", ["."]]
```
