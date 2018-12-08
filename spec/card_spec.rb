require "card"

describe Card do
  it "have a balance of zero" do
    expect(subject.balance).to eq 0
  end

  it "should respond to the top up method" do
    expect(subject).to respond_to :top_up
  end

  it "should add the money to the excistent balance" do
    card = Card.new
    expect(card.top_up(20)).to eq 20
  end

  it "should raise error if balance exceeds 90" do
    maximum = Card::LIMIT
    subject.top_up(maximum)
    expect{subject.top_up(1)}.to raise_error "limit exceeded"
  end

  #it 'starts off not in journey ie false' do
  #  expect(subject.in_journey?).to be false
  #end

  it 'starts off with empty journey list' do
    expect(subject.station_list).to eq []
  end

  context 'topping up and touching in' do
    fare = Card::MIN_FARE
    card = Card.new
    card.top_up(fare)
    let(:station){double :station}
    let(:station2){double :station2}
    card.touch_in(:station)

  #   it 'should touch-in' do
  #     expect(card.in_journey?).to be true
  #   end

  #   it 'should check if in journey' do
  #     expect(card).to be_in_journey
  #   end

  #  it 'should remember station' do
  #    expect(card.entry_station).to eq :station
  #  end

    # it 'should touch-out' do
    #   card.touch_out(:station2)
    #   expect(card).not_to be_in_journey
    # end

    # it 'nil entry station when touch-out' do
    #   card.touch_out(:station2)
    #   expect(card.entry_station).to eq nil
    # end
end

 context 'setting double' do
   let(:station){double :station}
  let(:station2){double :station2}

   it 'should check min-balance at touch in' do
    expect { subject.touch_in(station) }.to raise_error 'Insufficient funds'
   end

   it 'should deduct fare from balance at touch-out' do
    subject.top_up(Card::MIN_FARE)
    subject.touch_in(station)
    expect{ subject.touch_out(station2) }.to change{subject.balance}.by(-Card::MIN_FARE)
   end

   # it 'touching in and out saves a journey' do
   #   subject.top_up(Card::MIN_FARE)
   #   subject.touch_in(station)
   #   subject.touch_out(station2)
   #   expect(subject.station_list).to eq [{"entry_station"=>station,"exit_station"=>station2}]
   # end
 end

 context "Journey Specs" do
   let(:card) {Card.new}
   let(:station) {double :station}
   let(:station2) {double :station2}

   it "creates a journey on touch in" do
     card.top_up(Card::MIN_FARE)
     card.touch_in(station)
     expect(card.journey.entry_station).to eq station
   end

   it "creates complete journey on touch out" do
     card.top_up(Card::MIN_FARE)
     card.touch_in(station)
     card.touch_out(station2)
     expect(card.journey.total_journey).to eq ({station => station2})
   end

   it "appends complete journey to station list" do
     card.top_up(10)
     card.touch_in(station)
     card.touch_out(station2)
     expect(card.station_list).to eq([{station => station2}])
   end

 end


end
