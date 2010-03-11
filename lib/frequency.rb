class Frequency
  
  class Undefined < RuntimeError; end
  
  attr_accessor :plain_text

  # Notes:
  # * biweekly is ambiguous so I left it out
  # * biennially != biannually
  #
  # Values checked with Apple Dictionary Version 2.1.1 (80.1).
  FREQUENCIES       = {
    "each second"   => 315_360_000,
    "each minute"   =>   5_256_000,
    "each hour"     =>      87_600,
    "each day"      =>       3_650,
    "each week"     =>         520,
    "each month"    =>         120,
    "each quarter"  =>          40,
    "each year"     =>          10,
    "hourly"        =>      87_600,
    "daily"         =>       3_650,
    "weekly"        =>         520,
    "fortnightly"   =>         260,
    "monthly"       =>         120,
    "quarterly"     =>          40,
    "biannually"    =>          20,
    "semiannual"    =>          20,
    "semi-annual"   =>          20,
    "semiannually"  =>          20,
    "annual"        =>          10,
    "annually"      =>          10,
    "yearly"        =>          10,
    "biennial"      =>           5,
    "biennially"    =>           5,
    "quadrennial"   =>           2.5,
    "quadrennially" =>           2.5,
    "decade"        =>           1,
    "one time"      =>           0,
    "one-time"      =>           0,
    "other"         =>         nil,
    "unknown"       =>         nil,
  }
  
  def initialize(string)
    self.plain_text = string ? string.downcase : ''
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
    errors = find_errors([self, other])
    raise Undefined, errors.join(",") if !errors.empty?
    self.per_decade.send(method, other.per_decade)
  end
  
  def find_errors(objects)
    errors = []
    objects.each do |object|
      if object.per_decade.nil?()
        errors << %(Numerical value for "#{object.plain_text}" is undefined)
      end
    end
    errors
  end

end

