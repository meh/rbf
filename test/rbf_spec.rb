require 'rubygems'
require 'rbf'

describe RBF do
  describe '#parse' do
    it 'parses correctly "++[.,]"' do
      RBF.parse('++[.]').should == ["+", "+", ["."]]
    end

    it 'parses correctly "XD XD [PLS]" for Nintendo syntax' do
      RBF.parse('XD XD [PLS]', RBF::Syntax::Nintendo).should == ["+", "+", ["."]]
    end
  end

  describe '#optimize' do
    it 'optimizes correctly +- and -+' do
      RBF.optimize('+-').should == []
      RBF.optimize('-+').should == []
    end

    it 'optimizes correctly <> and ><' do
      RBF.optimize('<>').should == []
      RBF.optimize('><').should == []
    end

    it 'optimizes correctly empty loops' do
      RBF.optimize('[[][[[]]]]').should == []
    end

    it 'optimizes correctly +[+[+-]-]-' do
      RBF.optimize('+[+[+-]-]-').should == []
    end
  end
end
