# Apiフォルダ配下の
module Api
  # V1フォルダ配下の
  module V1
    # RestaurantsControllerです。ApplicationControllerを継承しています。
    class RestaurantsController < ApplicationController

      def index
        restaurants = Restaurant.all

        render json: {
          restaurants: restaurants
          # リクエストが成功した際に200 OKと一緒にデータを返す
        }, status: :ok
      end
    end
  end
end