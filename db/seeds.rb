# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 各レストランのデータを作成（3件）
3.times do |n|
  restaurant = Restaurant.new(
    name: "testレストラン_#{n}",
    fee: 100,
    time_required: 10,
  )

  # 各レストランのフード情報を作成（各12件）
  12.times do |m|
    restaurant.foods.build(
      name: "フード_#{m}",
      price: 500,
      description: "フード名_#{m}の説明文です。" ,
    )
  end

  # !（エクスクラメーションマーク）がついているメソッドはエラーが生じるとfalseを返すのではなく、例外（ActiveRecord::RecordNotFoundエラー）を発生させる
  # エラーが発生した場所や原因が分かりやすくなる。例外が起きた場所で処理を停止することができる等のメリットがある。
  restaurant.save!
end
