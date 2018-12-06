require_relative "journey"
require_relative "station"

class Card
  attr_reader :balance, :journey, :station_list

  LIMIT = 90
  MIN_FARE = 1

  def initialize
    @balance = 0
    @station_list=[]
  end

  def balance
    @balance
  end

  def top_up(money)
    raise "limit exceeded" if money + @balance > LIMIT
    @balance += money
  end

  def touch_in(entry_station)
    penalty_fare
    fail "Insufficient funds" if balance < MIN_FARE
    @journey = Journey.new(entry_station)
    #@entry_station = entry_station
  end

  # def in_journey?
  #   if entry_station == nil
  #     false
  #   else
  #     true
  #   end
  # end

 def touch_out(exit_station)
    deduct(MIN_FARE)
    station_list << @journey.total_journey(exit_station)
    # station_list.push({"entry_station"=>entry_station,"exit_station"=>exit_station})
    # @entry_station = nil
  end


private
  def deduct(fare)
    @balance -= fare
  end

  def penalty_fare
    if (journey != nil )
      if (journey.journey_complete? == false)
        deduct(10)
      end
    end
  end

end
