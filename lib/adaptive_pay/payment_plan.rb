module AdaptivePay
  class PaymentPlan

    attr_accessor :currency
    attr_reader :sender, :recipients

    def initialize(&block)
      @recipients = []
      yield self if block_given?
    end

    def sender=(sender_options)
      if sender_options.is_a?(AdaptivePay::Sender)
        @sender = sender_options
      else
        @sender = AdaptivePay::Sender.new sender_options
      end
    end

    def add_recipient(recipient_options)
      if recipient_options.is_a?(AdaptivePay::Recipient)
        @recipients << recipient_options
      else
        @recipients << AdaptivePay::Recipient.new(recipient_options)
      end
    end

  end
end
