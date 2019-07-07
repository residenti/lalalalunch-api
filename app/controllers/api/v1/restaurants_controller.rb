module Api
  module V1
    class RestaurantsController < ApiController
      include HttpRequest

      KEY_LIST = [
        "name", "name_kana", "latitude", "longitude", "category", "url",
        "url_mobile", "coupon_url", "image_url", "address", "tel", "opentime",
        "holiday", "parking_lots", "pr", "lunch", "credit_card", "e_money"
      ]

      # TODO
      # クエリパラメーターが存在すること.
      # res のハンドリング.
      def show
        res = get_request(params[:latitude], params[:longitude], params[:range], params[:late_lunch])

        res_body_json = JSON.parse(res.body) #TODO 0件の時を考慮した処理.

        restaurant = res_body_json["rest"].sample.select { |key| KEY_LIST.include?(key) }

        render(status: :ok, json: { result: { status: 0 }, restaurant: restaurant })

      # rescue ActiveRecord::RecordNotFound => e
      #   raise RecordNotFoundError.new('id' ,1)
      end

      private

        # TODO リファクタリング.
        def check_params
          missing_items = Array.new

          if params[:latitude].blank?
            missing_items.push("latitude")
          end

          if params[:longitude].blank?
            missing_items.push("longitude")
          end

          if params[:range].blank?
            missing_items.push("range")
          end

          if params[:late_lunch].blank?
            missing_items.push("late_lunch")
          end

          return if missing_items.blank?

          raise ParameterMissingError.new(missing_items)
        end

    end
  end
end
