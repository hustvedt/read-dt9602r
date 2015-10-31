class DT9602R
  def self.handle_row(data, &block)
    return [] if data.size < 14
    row = Array.new(12)
    begin
      number = Integer(data[0..4].map { |a| a.chr }.join, 10)
    rescue => er
      number = Float::NAN
    end

    case data[6] & 0xF
      when 0x0
      when 0x1
        number = (number * 0.001).round(3)
      when 0x2
        number = (number * 0.01).round(2)
      when 0x4
        number = (number * 0.1).round(1)
    end

    prefix = case (data[9]) >> 4
               when 0x0
                 ''
               when 0x1
                 'M'
               when 0x2
                 'k'
               when 0x4
                 'm'
               when 0x8
                 'u'
               else
                 ''
             end

    unit = case data[10]
             when 0x01
               'Fahrenheit'
             when 0x02
               'Celsius'
             when 0x04
               prefix = 'n'
               'Farad'
             when 0x08
               'Hertz'
             when 0x10
               ''
             when 0x20
               'Ohms'
             when 0x40
               'Amps'
             when 0x80
               'Volts'
           end

    row[0] = number
    row[1] = prefix
    row[2] = unit
    row[3] = 'AC' if data[7] & 0x8 ==0x8
    row[3] = 'DC' if data[7] & 0x10 ==0x10
    row[4] = 'Ground' if data[7] & 0x1 ==0x1
    row[5] = 'Hold' if data[7] & 0x2 ==0x2
    row[6] = 'Delta' if data[7] & 0x4 ==0x4
    row[7] = 'Auto' if data[7] & 0x20 ==0x20
    row[8] = 'Capacitor' if data[8] & 0x2 == 0x2
    row[9] = 'LowBat' if data[8] & 0x8 == 0x8
    row[10] = 'Min' if data[8] & 0x10 == 0x10
    row[11] = 'Max' if data[8] & 0x20 == 0x20
    row[12] = 'Duty' if data[9] & 0x2 == 0x2
    row[13] ='Diode' if data[9] & 0x4 == 0x4

    block.yield(row)
  end
end