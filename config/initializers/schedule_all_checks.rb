Check.all.each do |check|
  CheckWorker.perform_async(check.id)
end