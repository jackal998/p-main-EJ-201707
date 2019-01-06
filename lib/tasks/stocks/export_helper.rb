def args_check(args)
  temp = {}
  args.each { |k,v| temp[k] = v }
  temp[:company_code] = false unless args.company_code.to_s =~ /^\d{4}$/
  temp[:start_date] = args.start_date.to_date
  temp[:end_date] = args.end_date == "empty" ? temp[:start_date].end_of_month : args.end_date.to_date
  return temp
end