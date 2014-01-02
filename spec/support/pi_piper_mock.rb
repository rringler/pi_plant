module PiPiper
  class Pin
    def initialize(options = {})

    end

    def method_missing(meth, *args, &block)
      #puts "Would be calling '#{meth}' with '#{args.inspect}'"
    end
  end

  class Spi
    def self.begin(*args, &block)

    end
  end
end
