require './delimiter_parser'

class StringCalculator
  def add(string_number)
    sum_positives_bigger_than_1000(numbers(string_number))
  end

  private

  def sum_positives_bigger_than_1000(numbers)
    raise_if_negatives(numbers)
    numbers.reject{|number| number > 1000}.inject(0, &:+)
  end

  def raise_if_negatives(numbers)
    negatives = numbers.select { |number| number < 0 }
    if negatives.length > 0
      raise Exception.new("negative numbers: #{negatives}")
    end
  end

  def numbers(string_number)
    split(string_number).map(&:to_i)
  end

  def split(string_number)
    string_number.split(/#{delimiters_regexp(string_number)}/)
  end

  def delimiters_regexp(string_number)
    delimiters(string_number).join("|")
  end

  def delimiters(string_number)
    DelimiterParser.new(string_number).delimiters
  end
end

