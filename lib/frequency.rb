class Frequency
  
  class Undefined < RuntimeError; end
  
  attr_accessor :plain_text

  # Notes:
  # * biweekly is ambiguous so I left it out
  # * biennially != biannually
  #
  # Values checked with Apple Dictionary Version 2.1.1 (80.1).
  FREQUENCIES       = {
    "each second"   => [315_360_000,   true ],
    "each minute"   => [  5_256_000,   true ],
    "hourly"        => [     87_600,   true ],
    "each hour"     => [     87_600,   false],
    "daily"         => [      3_650,   true ],
    "each day"      => [      3_650,   false],
    "weekly"        => [        520,   true ],
    "each week"     => [        520,   false],
    "fortnightly"   => [        260,   true ],
    "monthly"       => [        120,   true ],
    "each month"    => [        120,   false],
    "quarterly"     => [         40,   true ],
    "each quarter"  => [         40,   false],
    "biannually"    => [         20,   true ],
    "semiannual"    => [         20,   false],
    "semi-annual"   => [         20,   false],
    "semiannually"  => [         20,   false],
    "annually"      => [         10,   true ],
    "each year"     => [         10,   false],
    "yearly"        => [         10,   false],
    "annual"        => [         10,   false],
    "biennially"    => [          5,   true ],
    "biennial"      => [          5,   false],
    "quadrennially" => [          2.5, true ],
    "quadrennial"   => [          2.5, false],
    "each decade"   => [          1,   true ],
    "decade"        => [          1,   false],
    "one time"      => [          0,   true ],
    "one-time"      => [          0,   false],
    "other"         => [        nil,   true ],
    "unknown"       => [        nil,   true ],
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
    return nil unless value
    return nil unless value[0]
    value[0]
  end
  
  def per_year
    value = FREQUENCIES[plain_text]
    return nil unless value
    return nil unless value[0]
    value[0] / 10.0
  end

  def valid?
    FREQUENCIES.keys.include?(self.plain_text)
  end

  # A list suitable for a drop-down list
  def self.list
    list = []
    sortable = FREQUENCIES.select { |k, v| v[0] } # not nil
    sorted = sortable.sort_by { |k, v| -v[0] }
    sorted.each { |k, v| list << k if v[1] }
    nil_values = FREQUENCIES.select { |k, v| v[0].nil? }.sort_by { |k, v| k }
    nil_values.each { |k, v| list << k }
    list
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
