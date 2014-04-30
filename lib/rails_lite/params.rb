require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    query_params = parse_www_encoded_form(req.query_string)
    body_params = parse_www_encoded_form(req.body)
    @params = route_params.merge(query_params).merge(body_params)
  end

  def [](key)
    @params[key]
  end

  def permit(*keys)
    @permitted.nil? ? @permitted = keys : @permitted += keys
  end

  def require(key)
    raise AttributeNotFoundError unless @params.keys.include?(key)
  end

  def permitted?(key)
    @permitted.include?(key)
  end

  def to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private

  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    return {} if www_encoded_form.nil?
    param_arr = URI.decode_www_form(www_encoded_form)
    param_hash = {}
    param_arr.each do |param|
      parsed_arr = parse_key(param.first) + [param.last]
      new_hash = hashify(parsed_arr)
      param_hash = new_hash.merge(param_hash)
    end
    param_hash
  end

  def hashify(array)
    return array.first if array.length == 1
    new_hash = {}
    new_hash[array.first] = hashify(array[1..-1])
    new_hash
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
