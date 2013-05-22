class DelimiterParser
  def initialize(string_numbers)
    @string_numbers = string_numbers
  end

  def delimiters
    default_delimiters + custom_delimiters
  end

  def default_delimiters
    %W(, \n)
  end

  def custom_delimiters?
    @string_numbers.start_with?("//")
  end

  def custom_delimiters
    return [] if ! custom_delimiters?

    delimiters_string = [@string_numbers[2,limit_char_index-2]]

  end

  def limit_char_index
    @string_numbers.index("\n")
  end
end