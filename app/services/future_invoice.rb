class FutureInvoice
  def initialize customer, quantity_changed
    @customer = customer
    @subscription = customer.subscriptions.data.first if customer.subscriptions.data.length > 0

    quantity_changed[:core] ||= 0
    quantity_changed[:pro] ||= 0
    if quantity_changed[:core] > 0 && quantity_changed[:pro] > 0
      raise "Only allow changing 1 app subscription at a time"
    end
    
    @quantity_diff = quantity_changed
    @plan_ids = App.plans_to_id
  end
  
  def invoice
    return @invoice if @invoice
    
    params = {customer: @customer.id}
    
    if @subscription
      params[:subscription] = @subscription.id
      params[:subscription_prorate] = true
    end
    
    params[:subscription_items] = subscription_items

    @invoice ||= Stripe::Invoice.upcoming(params)
  end
  
  def prorated_total
    invoice.lines.data.select { |ii| ii.proration? && ii.period.start == invoice.subscription_proration_date }.sum(&:amount)
  end
  
  def monthly_increase
    return 900 if @quantity_diff[:core] > 0
    return 2900 if @quantity_diff[:pro] > 0
    raise "uh oh"
  end
  
  private
  def subscription_items
    if @subscription
      [:core, :pro].map {|plan|
        {id: find_subscription_item_by_plan(plan).id,
         quantity: find_subscription_item_by_plan(plan).quantity + @quantity_diff[plan]}
      }
    else
      [:core, :pro].map {|plan|
        {plan: @plan_ids[plan], quantity: @quantity_diff[plan]}
      }
    end
  end
  
  def find_subscription_item_by_plan plan
    @subscription.items.data.find{ |i| i.plan.id == @plan_ids[plan] }
  end
end