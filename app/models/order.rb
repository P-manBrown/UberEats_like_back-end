class Order < ApplicationRecord
  has_many :line_foods

  validates :total_price, numericality: { greater_than: 0 }

  def save_with_update_line_foods!(line_foods)
    # ActiveRecord::Base.transactionは分割不可能な複数のレコードの更新を1つの単位にまとめて処理する
    # まとめた処理のうちいずれか一つでも例外が発生すれば全ての処理が行われなくなる
    # 例外が発生した場合にロールバックする
    ActiveRecord::Base.transaction do
      line_foods.each do |line_food|
        # rails6.1以降ではupdate_attributesメソッドは非推奨となっている
        # updateで書き換える
        line_food.update!(active: false, order: self)
      end
      self.save!
    end
  end

end