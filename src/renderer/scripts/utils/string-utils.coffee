# String関連のUtil
module.exports =
  # 空判定
  isEmpty: (str) ->
    !str? || str.length < 1
