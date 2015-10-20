class LocalStorage
  @name
  @initialValue
  @jsonEncodable
  @data
  constructor: (@name, @initialValue = null, @jsonEncodable = false) ->
    @load()
  load: ->
    data = localStorage.getItem @name
    if data?
      @data = if @jsonEncodable then JSON.parse data else data
    else
      @data = @initialValue
  save: ->
    localStorage.setItem @name, if @jsonEncodable then JSON.stringify @data else @data

module.exports = LocalStorage
