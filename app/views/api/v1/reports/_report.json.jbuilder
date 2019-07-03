expected_locals = %w(report)
expected_locals.each do |local|
  raise("_report expects local #{local}") unless binding.local_variable_get(local)
end

json.id             report.id
json.report_type    report.report_type
json.user_id        report.user_id
json.receiver_id    report.receiver_id
json.created_at     report.created_at
json.updated_at     report.updated_at