module Api
  module V1
    class RestaurantsController < ApplicationController
      require 'net/https'

      # TODO
      # エラーハンドリング ERROR 用クラス作成する.
      # https リクエストの処理もどこかにまとめる. lib/ 配下とか?
      def show

        # hash形式でパラメタ文字列を指定し、URL形式にエンコード
        params = URI.encode_www_form(
          {
            keyid: SECRET_SETTINGS[:gnavi_keyid],
            hit_per_page: 1,
            input_coordinates_mode: 1,
            latitude: 35.726973099999995,
            longitude: 139.521121,
            range: 5,
            late_lunch: 1,
            lunch: 1
          }
        )

        uri = URI.parse(File.join(SETTINGS[:base_url], "?#{params}")) # URIを解析し、hostやportをバラバラに取得できるようにする

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true # https通信を許可.
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE # 証明書なんたらかんたら...

        res = http.get(uri.request_uri)

        restaurant = JSON.parse(res.body)

        render(status: :ok, json: { result: { status: 0 }, restaurant: restaurant })

      end

    end
  end
end
