module TimeShift
  def self.add_months(number)
    time = DateTime.now
    time = (time >> number).to_time
  end
    
  def self.add_days(number)
     time = DateTime.now
     time = (time + number).to_time
  end
  
  def self.sub_days(number)
    time = DateTime.now
    time = (time - number).to_time
  end
  
  def self.sub_months(number)
    time = DateTime.now
    time = (time << number).to_time
  end
end