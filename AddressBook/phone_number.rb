# PHONE NUMBER class to store contact phone numbers

class PhoneNumber
  attr_accessor :kind, :number

  def to_s
    "#{kind}: #{number}"
  end
end
