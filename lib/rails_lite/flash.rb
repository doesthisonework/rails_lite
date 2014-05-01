class Flash
  attr_accessor :now

  def initialize(req)
    flash = req.cookies.select { |c| c.name == '_rails_lite_flash' }.first
    @now = Hash.new { |hash, key| hash[key] = [] }
    JSON.parse(flash.value).merge(@now) if flash
    @flash = Hash.new { |hash, key| hash[key] = [] }
  end

  def [](key)
    @now[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

  def store_flash(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_flash', @flash.to_json)
  end
end
