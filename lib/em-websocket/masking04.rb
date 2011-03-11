module EventMachine
  module WebSocket
    class MaskedString < String
      def read_mask
        raise "Too short" if bytesize < 4 # TODO - change
        @masking_key = String.new(self[0..3])
      end

      def slice_mask
        slice!(0, 4)
      end

      def getbyte(index)
        super(index + 4) ^ @masking_key.getbyte(index % 4)
      end

      def getbytes(start_index, count)
        data = ''
        count.times do |i|
          data << getbyte(start_index + i)
        end
        data
      end
    end

    module Masking04
      attr_accessor :masking_key

      def unmask(data, position)
        unmasked_data = ""
        data.size.times do |i|
          unmasked_data << (data.getbyte(i) ^ masking_key.getbyte(position % 4))
          position += 1
        end
        unmasked_data
      end
    end
  end
end
