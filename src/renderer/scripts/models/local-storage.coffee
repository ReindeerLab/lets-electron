# localStorageへの入出力を管理
class LocalStorage
  @name
  @initialValue
  @jsonEncodable
  @data
  # name: localStorageのkey
  # initialValue: localStorageに存在しなかった場合の初期値
  # jsonEncodable: localStorageへの入出力時にjsonを使用するかどうか
  constructor: (@name, @initialValue = null, @jsonEncodable = false) ->
    @load()
  # localStorageからデータを読み込む
  # 値が存在しない場合はinitialValueで上書きする
  load: ->
    data = localStorage.getItem @name
    if data?
      @data = if @jsonEncodable then JSON.parse data else data
    else
      @data = @initialValue
  # 現在のデータの状態をlocalStorageに保存する
  save: ->
    localStorage.setItem @name, if @jsonEncodable then JSON.stringify @data else @data

module.exports = LocalStorage
