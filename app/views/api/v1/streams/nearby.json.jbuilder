json.array! @streams do |stream| 
  json.partial! "stream", stream: stream
end