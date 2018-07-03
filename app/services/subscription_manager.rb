class SubscriptionManager
  def initialize customer
    @customer = customer
  end
  
  def modify
    # if estimate > 0, upgrade
    # else downgrade
  end
  
  def estimate new_plan_quantities
    new_plan_quantities[:core] ||= 0
    new_plan_quantities[:pro] ||= 0
    return 0 if ((new_plan_quantities[:core] == 0) && (new_plan_quantities[:pro] == 0))
    
    params = {customer: @customer.id}
    if @customer.subscriptions.data.length > 0
      subscription = @customer.subscriptions.data[0]

      new_plan_quantities[:core] = subscription.items.data.find{ |i| i.plan.id == "plan_D6LP7fkX00U1Tm" }.quantity + (new_plan_quantities[:core] || 0)
      new_plan_quantities[:pro] = subscription.items.data.find{ |i| i.plan.id == "plan_D6LQ51tBxhzCFI" }.quantity + (new_plan_quantities[:pro] || 0)
      
      params[:subscription] = subscription.id
      params[:subscription_prorate] = true
      params[:subscription_items] = [{id: subscription.items.data.find{ |i| i.plan.id == "plan_D6LP7fkX00U1Tm" }.id,
                                      quantity: new_plan_quantities[:core]},
                                     {id: subscription.items.data.find{ |i| i.plan.id == "plan_D6LQ51tBxhzCFI" }.id,
                                      quantity: new_plan_quantities[:pro]}]

      iv = Stripe::Invoice.upcoming(params)
      return iv.lines.data.select { |i| i.period.start == iv.subscription_proration_date }.sum {|i| i.amount }
    else
      params[:subscription_items] = [{plan: "plan_D6LP7fkX00U1Tm",
                                      quantity: new_plan_quantities[:core]},
                                     {plan: "plan_D6LQ51tBxhzCFI",
                                      quantity: new_plan_quantities[:pro]}]
      return Stripe::Invoice.upcoming(params).amount_due
    end
  end

  def resume_unpaid
  end
end