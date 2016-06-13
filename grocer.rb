

def consolidate_cart(cart:[])
  cart.uniq.each_with_object({}) do |item, cart_hash|
    cart_hash[item.keys.join] ||= item[item.keys.join]
    cart_hash[item.keys.join][:count] = cart.count(item)
  end
end

def apply_coupons(cart:[], coupons:[])
  return cart if coupons.length == 0

  # if counter is outside the loop then it won't reset for multiple items
  # if counter is inside the loop then if more than one coupon applies for one item, the count will not increment
  cart2 = cart.dup
  coupons.uniq.each do |coupon|
    
    item = coupon[:item]    
    
    return cart if !cart.keys.include?(coupon[:item])

    x = cart2[item][:count] / coupon[:num]
    y = cart2[item][:count] % coupon[:num]

    cart[item][:count] = y
    cart["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[item][:clearance], :count => x}
  end

  cart
end

def apply_clearance(cart:[])

  cart.each do |item,attr|
    attr[:clearance] == true ? attr[:price] -= attr[:price] * 1/5 : attr[:price]
  end
end

def checkout(cart: [], coupons: [])
  cost = 0
  new_cart = consolidate_cart(cart: cart)

  cart = apply_coupons(cart: new_cart, coupons: coupons)

  cart = apply_clearance(cart: cart)

  new_cart.each {|key,val| cost += val[:price] * val[:count] if val[:count] > 0}

  cart.each do |item,attr|
    attr[:clearance] == false ? clearance = false : clearance = true
  end

  cost > 100 ? cost -= cost * 1/10 : cost
end


