module Api
  module V1
    class OrdersController < ApplicationController
      def create
        # 配列で送られてくるline_food_idsを渡すことで合致するidのデータを取得する
        posted_line_foods = LineFood.where(id: params[:line_food_ids])
        # 上記で取得したデータの総計をOrder.newしてorderインスタンスを生成
        order = Order.new(
          total_price: total_price(posted_line_foods),
        )
        # トランザクション（orderモデルに記述）
        if order.save_whith_update_line_foods:(posted_line_foods)
          # 成功した場合に空データとno_content
          render json: {}, status: :no_content
        else
          # 失敗した場合にはinternal_server_errorを返す
          render json: {}, status: :internal_server_error
        end
      end

      private

      def total_price(posted_line_foods)
        posted_line_foods.sum { |line_food| line_food.total_amount } + posted_line_foods.first.restaurant.fee
      end
    end
  end
end