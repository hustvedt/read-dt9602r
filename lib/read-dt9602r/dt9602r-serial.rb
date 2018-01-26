require 'rubyserial'
class DT9602R_Serial
  def read(serial_port, &block)
    sp = Serial.new(serial_port, 2400, 8, vmin: 1)

    data = []
    loop do
      byte = sp.getbyte
      unless byte.nil?
        data << byte
        if data.size > 2 && data[-2] == 0x0d &&data[-1] == 0x0a
          DT9602R.handle_row(data, &block)
          data = []
        end
      end
    end
  end
end
