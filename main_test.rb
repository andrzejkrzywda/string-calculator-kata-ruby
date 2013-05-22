require 'test/unit'
require './string_calculator'


class DelimiterParserTest < Test::Unit::TestCase

  def test_delimiters
    assert_delimiters(default_delimiters, "1,2")
    assert_delimiters(default_delimiters, "1\n2")
    assert_delimiters(default_delimiters + [";"], "//;\n1;2")
    assert_delimiters(default_delimiters+["+"], "//+\n1+2")
    assert_delimiters(default_delimiters+["**"], "//**\n1**2")
    assert_delimiters(default_delimiters+["****"], "//****\n1****2")
    assert_delimiters(default_delimiters+["*", "%"], "//[*][%]\n1*2%3")
    pending "foo"
  end

  def default_delimiters
    [",", "\n"]
  end

  def assert_delimiters(expected, string_numbers)
    assert_equal(expected, DelimiterParser.new(string_numbers).delimiters)
  end

end

class CalculatorTest < Test::Unit::TestCase

  def test_acceptance
    assert_calculator_add(6, "//[*][%]\n1*2%3")
  end

  def test_simple_add
    assert_calculator_add(0, "")
    assert_calculator_add(1, "1")
    assert_calculator_add(2, "2")
    assert_calculator_add(10, "10")
    assert_calculator_raises("-1", "[-1]")
  end

  def test_handles_comma_delimiter
    assert_correct_calculator_add(",")
  end

  def test_handles_newline_delimiter
    assert_correct_calculator_add("\n")
  end

  def test_handles_any_delimiter
    delimiter = ":"
    assert_calculator_add(3, "//#{delimiter}\n1#{delimiter}2")
    delimiter = ";"
    assert_calculator_add(4, "//#{delimiter}\n2#{delimiter}2")
    assert_calculator_add(6, "//#{delimiter}\n1#{delimiter}2#{delimiter}3")
    assert_calculator_raises("//#{delimiter}\n1#{delimiter}-2#{delimiter}-3", "[-2, -3]")
  end

  def assert_correct_calculator_add(delimiter)
    assert_calculator_add(3, "1#{delimiter}2")
    assert_calculator_add(4, "2#{delimiter}2")
    assert_calculator_add(6, "1#{delimiter}2#{delimiter}3")
    assert_calculator_raises("1#{delimiter}-2#{delimiter}-3", "[-2, -3]")
    #ignore numbers > 1000
    assert_calculator_add(1002, "2#{delimiter}1000")
    assert_calculator_add(2, "2#{delimiter}1001")
  end

  def assert_calculator_add(expected, string)
    assert_equal(expected, StringCalculator.new.add(string))
  end

  def assert_calculator_raises(numbers_string, expected_error_message)
    exception = assert_raises Exception do
      StringCalculator.new.add(numbers_string)
    end
    assert_equal("negative numbers: #{expected_error_message}", exception.message)
  end
end

