module Api
  module V1
    class RestaurantsController < ApiController
      include HttpRequest

      before_action :check_params, only: [:show]

      KEY_LIST = [
        "name", "name_kana", "latitude", "longitude", "category", "url",
        "url_mobile", "coupon_url", "image_url", "address", "tel", "opentime",
        "holiday", "parking_lots", "pr", "lunch", "credit_card", "e_money"
      ]

      # TODO
      # res が0件の場合の処理.
      def show
        res = get_request(params[:latitude], params[:longitude], params[:range], params[:late_lunch])

        res_body_json = JSON.parse(res.body)

        restaurant = res_body_json["rest"].sample.select { |key| KEY_LIST.include?(key) }

        render(status: :ok, json: { result: { status: 0 }, restaurant: restaurant })

      # rescue ActiveRecord::RecordNotFound => e
      #   raise RecordNotFoundError.new('id' ,1)
      end

      private

        # キーが存在しない場合は、バリューをチェックせずエラーをあげる.
        def check_params
          check_key
          check_value
        end

        # パラメーターにキー自体が存在するかのチェック.
        def check_key
          missing_items = Array.new

          missing_items.push("latitude") unless params.has_key?(:latitude)
          missing_items.push("longitude") unless params.has_key?(:longitude)
          missing_items.push("range") unless params.has_key?(:range)
          missing_items.push("late_lunch") unless params.has_key?(:late_lunch)

          return if missing_items.blank?

          raise ParameterKeyMissingError.new(missing_items)
        end

        # パラメーターにバリューが存在するかのチェック.
        # 先にキーの存在を確認してから実施しないとエラーになるので気をつける.
        def check_value
          missing_items = Array.new

          missing_items.push("latitude") if params[:latitude].blank?
          missing_items.push("longitude") if params[:longitude].blank?
          missing_items.push("range") if params[:range].blank?
          missing_items.push("late_lunch") if params[:late_lunch].blank?

          return if missing_items.blank?

          raise ParameterValueMissingError.new(missing_items)
        end

    end
  end
end
