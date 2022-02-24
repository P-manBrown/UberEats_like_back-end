module Api
  module V1
    class LineFoodsController < ApplicationController
      # before_action :フィルタアクション名 :onlyをつけることで特定のアクションのみにて適用できる
      before_action :set_food, only: %i[create]

      def create
        # activeスコープとorder_restaurantスコープを組み合わせて「他店舗でアクティブなLineFoodをActiveRecord_Relationで取得する
        # exists?で存在するかを判定
        if LineFood.active.order_restaurant(@ordered_food.retaurant.id).exists?
          return render json: {
            # 既に作成されている他店舗の情報
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            # new_restaurantで作成しようとした新店舗の情報
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
            # 406 not_acceptableを返す
          }, status: :not_acceptable
        end
        set_line_food(@ordered_food)

        if @line_food.save
          # 保存が成功した場合にはcreatedと保存したデータを返す
          render json: {
            line_food: @line_food
          }, status: :created
        else
          # エラーが発生した場合には500系のエラーを返す。フロントでエラー画面を表示することができる
          render json: {}, status: :internal_server_error
        end
      end


      private
      # set_foodはこのコントローラ内でしか使用しないためprivateに記述する
      # 特定のコントローラ内でしか使用しないアクションはprivateに記述する
      def set_food
        @ordered_food = Food.find(params[:food_id])
      end

      def set_line_food(ordered_food)
        # line_foodが存在するか判定。presentはexsistと違い、全ての結果に対してtrueかfalseを返す
        if ordered_food.line_food.present?
          # ローカル変数では他のアクションで使用できないため、インスタンス変数にする
          # 既存のデータを更新する処理
          @line_food = ordered_food.line_food
          @line_food.attributes = {
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else
          # 新しくline_foodを作成
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end

