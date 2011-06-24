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
      RBF.optimize(RBF.parse('+-')).should == []
      RBF.optimize(RBF.parse('-+')).should == []
    end
  end
end
