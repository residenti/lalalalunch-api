module Api
  module V1
    class RestaurantsController < ApiController
      include HttpRequest

      KEY_LIST = [
        "name", "name_kana", "latitude", "longitude", "category", "url",
        "url_mobile", "coupon_url", "image_url", "address", "tel", "opentime",
        "holiday", "parking_lots", "pr", "lunch", "credit_card", "e_money"
      ]

      def show
        res = get_request(params[:latitude], params[:longitude], params[:range], params[:late_lunch])

        res_body_json = JSON.parse(res.body) #TODO 0件の時を考慮した処理.

        restaurant = res_body_json["rest"].sample.select { |key| KEY_LIST.include?(key) }

        render(status: :ok, json: { result: { status: 0 }, restaurant: restaurant })

      # rescue ActiveRecord::RecordNotFound => e
      #   raise RecordNotFoundError.new('id' ,1)
      end

    end
  end
end
