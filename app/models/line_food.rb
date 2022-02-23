# クラスメソッド（self.メソッド名）インスタンスメソッド（メソッド名）の使い分け
# クラスメソッドは全データに対する操作（全体からデータを検索する等）インスタンスメソッドは特定のデータに対する操作（姓+名でフルネームを作成する場合等）で使い分ける

class LineFood < ApplicationRecord
  belongs_to :food
  belongs_to :restaurant
  # optional: trueを指定すると関連づけを任意にすることができる
  # 以下の場合にはorder_idがnullでもエラーは発生しない
  belongs_to :order, optional: true

  validates :count, numericality: { greater_than: 0 }

  # scopeはモデルや関連するオブジェクトに対するクエリを指定することができる
  # scopeの戻り値は必ず
  scope :active, -> { where(active: true) }
  # scopeには引数を渡すことができる
  scope :other_restaurant, -> (picked_restaurant_id) { where.not(restaurant_id: picked_restaurant_id)}

  # 以下インスタンスメソッド。コントローラーではなく、モデルに記述することで再利用性が高まる
  def total_amount
    food.price * count
  end
end