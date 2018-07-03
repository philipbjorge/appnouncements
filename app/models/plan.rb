class Plan
  def self.allowed_plans
    [:free, :core_unlimited, :pro_unlimited]
  end
  
  def self.sym_to_stripe_id sym
    {
        core_unlimited: "plan_DACcyNkZBZOCEu",
        pro_unlimited: "plan_DACjUKRCzYWE3A"
    }[sym]
  end
  
  def initialize subscription
    @subscription = subscription
    @plan = plan_from_stripe_id(subscription&.plan&.id)
  end
  
  def last_day_of_service
    return Time.at(@subscription.current_period_end) if pending_cancelation?
  end
  
  def pending_cancelation?
    @subscription.cancel_at_period_end
  end
  
  def canceled?
    @subscription.status == "canceled"
  end
  
  def to_sym
    return @plan
  end
  
  def allowed_apps
    return 1 if @plan == :free
    return Float::INFINITY
  end
  
  private
  def plan_from_stripe_id plan
    return :core_unlimited if plan  == "plan_DACcyNkZBZOCEu"
    return :pro_unlimited if plan == "plan_DACjUKRCzYWE3A"
    return :free
  end
end