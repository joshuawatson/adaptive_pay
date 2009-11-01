module AdaptivePay
  class Response

    def initialize(type, response)
      @type = type
      @attributes = {}
      parse response
    end

    def success?
      !!@success
    end

    def payment_page_url
      case @type
      when :approval
        "https://www.paypal.com/webscr?cmd=_ap-preapproval&preapprovalkey=#{URI.escape(preapproval_key)}"
      when :payment
        "https://www.paypal.com/webscr?cmd=_ap-payment&paykey=#{URI.escape(pay_key)}"
      end
    end

    def read_attribute(name)
      @attributes[name]
    end

    def method_missing(name, *args)
      if @attributes.has_key?(name.to_s.camelize(:lower))
        @attributes[name.to_s.camelize(:lower)]
      else
        super
      end
    end

    protected
      def parse(response)
        unless response.code.to_s == "200"
          @success = false
          return
        end

        response.body.to_s.split("&").each do |fragment|
          k, v = fragment.split("=")
          @attributes[k] = URI.unescape(v)
        end

        @success = %w{Success SuccessWithWarning}.include?(read_attribute("responseEnvelope.ack"))
      end

  end
end
