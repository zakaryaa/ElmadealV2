json.promotions @promotions do |promotion|
  json.percentage promotion.percentage.to_s + "%"
end