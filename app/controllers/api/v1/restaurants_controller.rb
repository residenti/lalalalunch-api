module Api
  module V1
    class RestaurantsController < ApiController
      include HttpRequest

      def show

        res = get_request(35.726973099999995, 139.521121, 5, 1)

        restaurant = JSON.parse(res.body)

        render(status: :ok, json: { result: { status: 0 }, restaurant: restaurant })

      # rescue ActiveRecord::RecordInvalid => e
      #   raise ValidationError.new(errors ,e)
      end

    end
  end
end
