class Frequency
  
  class Undefined < RuntimeError; end
  
  attr_accessor :plain_text

  # Source: the Macintosh built-in dictionary:
  # Notes:
  # * biweekly is ambiguous so I left it out
  # * biennially != biannually
  FREQUENCIES = {
    "each second"  => 315_360_000,
    "each minute"  =>   5_256_000,
    "each hour"    =>      87_600,
    "each day"     =>       3_650,
    "each week"    =>         520,
    "each month"   =>         120,
    "each quarter" =>          40,
    "each year"    =>          10,
    "hourly"       =>      87_600,
    "daily"        =>       3_650,
    "weekly"       =>         520,
    "monthly"      =>         120,
    "quarterly"    =>          40,
    "biannually"   =>          20,
    "annual"       =>          10,
    "annually"     =>          10,
    "yearly"       =>          10,
    "biennial"     =>           5,
    "biennially"   =>           5,
    "decade"       =>           1,
    "one time"     =>           0,
    "one-time"     =>           0,
    "other"        =>         nil,
    "unknown"      =>         nil,
  }
  
  def initialize(string)
    self.plain_text = string
  end
  
  def ==(other)
    compare_safely(:==, other)
  end
  
  def <=>(other)
    compare_safely(:<=>, other)
  end

  def <(other)
    compare_safely(:<, other)
  end

  def <=(other)
    compare_safely(:<=, other)
  end
  
  def >(other)
    compare_safely(:>, other)
  end

  def >=(other)
    compare_safely(:>=, other)
  end
  
  def per_decade
    value = FREQUENCIES[plain_text]
    value ? value : nil
  end
  
  def per_year
    value = FREQUENCIES[plain_text]
    value ? (value / 10.0) : nil
  end

  def valid?
    FREQUENCIES.keys.include?(self.plain_text)
  end
  
  protected
  
  def compare_safely(method, other)
    if self.per_decade.nil?
      raise Undefined, %(Numerical value for "#{self.plain_text}" is undefined, ) +
        %( therefore a comparison with "#{other.plain_text}" is impossible)
    elsif other.per_decade.nil?
      raise Undefined, %(Numerical value for "#{other.plain_text}" is undefined, ) +
        %( therefore a comparison with "#{self.plain_text}" is impossible)
    else
      self.per_decade.send(method, other.per_decade)
    end
  end

end

