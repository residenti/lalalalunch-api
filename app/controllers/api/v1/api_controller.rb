module Api
  module V1

    class ApiController < ApplicationController

      rescue_from Exception, with: :handle_error

      # 共通エラーハンドリング.
      # error: エラーオブジェクト.
      def handle_error(error = nil)

        if error.blank?
          Rails.logger.fatal("#{self.class.name}: [予期しないエラー]. params: #{params.inspect}")
          error = ApiError.new
        elsif error.is_a?(ApiError)
          Rails.logger.info("#{self.class.name}: #{error.message} params: #{params.inspect}")
        else
          Rails.logger.fatal("#{self.class.name}: #{error.message} params: #{params.inspect}")
          Rails.logger.fatal(error.backtrace.join("\n"))
          error = ApiError.new
        end

        render(status: error.response_http_status, json: error.create_response_body)

      end

    end

    class ApiError < StandardError

      attr_reader :response_http_status

      # コンストラクタ
      # message: システム内でエラーの内容を把握するためのメッセージ.
      # response_status: クライアントに返却するステータスコード.
      # response_http_status: クライアントに返却するHTTPステータス.
      # response_message: クライアントへ返却するレスポンスBodyのmessage要素なる文字列.
      # response_errors: クライアントへ返却するレスポンスBodyのerrors要素となるHashオブジェクト.
      def initialize(
        message = "[予期しないエラー]",
        response_http_status = 500,
        response_status = 9,
        response_message = "An unexpected error occurred.",
        response_errors = nil
      )

        super(message)

        @response_http_status = response_http_status
        @response_status = response_status
        @response_message = response_message
        @response_errors = response_errors

      end

      def create_response_body

        {
          result: {
            status: @response_status 
          },
          error: {
            message: @response_message,
            type: self.class.name.split('::').last,
            details: @response_errors
          }
        }

      end

    end

    # パラメーターキー不足エラー.
    class ParameterKeyMissingError < ApiError

      # コンストラクタ
      # missing_items: 不足しているパラメーターキー.
      def initialize(missing_items)

        response_status = 1
        response_message = create_response_message(missing_items)

        super("[パラメーターキー不足エラー]", 400, response_status, response_message)

      end

      private

        def create_response_message(missing_items)

          "[key = #{missing_items.join(', ')}] was not found."

        end

    end

    # パラメーターバリュー不足エラー.
    class ParameterValueMissingError < ApiError

      # コンストラクタ
      # missing_items: 不足しているパラメーターバリュー.
      def initialize(missing_items)

        response_status = 1
        response_message = create_response_message(missing_items)

        super("[パラメーターバリュー不足エラー]", 400, response_status, response_message)

      end

      private

        def create_response_message(missing_items)

          "[value = #{missing_items.join(', ')}] is blank."

        end

    end

    # 指定された店舗の情報が存在しないエラー.
    class RestaurantNotFoundError < ApiError

      # コンストラクタ
      # error: ぐるなびApiのerror オブジェクト.
      def initialize(error)

        response_status = 1

        super(error["message"], error["code"], response_status, "Restaurant was not found.")

      end

    end

    # TODO パラメーターエラー系の識別をクライアント側で行えないので修正が必要.
    # 不正なパラメータが指定されたエラー.
    class InvalidParameterError < ApiError

      # コンストラクタ
      # error: ぐるなびApiのerror オブジェクト.
      def initialize(errors)

        message = "パラメーター不正エラー"
        response_status = 1

        super(message, 400, response_status, "Parameters is invalid.")

      end

    end

    # バリデーションエラー.
    class ValidationError < ApiError

      # エラーコード.
      CODE = {
        REQUIRED: "001",      # 必須
        OVER_LENGTH: "002",   # 最大文字数超過
        INVALID_FORMAT: "003" # 形式不正
      }.freeze

      # コンストラクタ.
      # errors: ActiveRecordのerrors オブジェクト.
      # e: ActiveRecord::RecordInvalid オブジェクト.
      def initialize(errors, e = nil)

        message = e.present? ? e.message : "[バリデーションエラー]"
        response_status = 1
        response_errors = create_response_errors(errors)

        super(message, 400, response_status, "Parameters is invalid", response_errors)

      end

      private

        def create_response_errors(errors)

          errors.messages.map do |key, error_array|

            custom_error_array = error_array.map do |error|
              case
              when error == "を入力してください。"
                {code: CODE[:REQUIRED]}
              when m = error.match(/\Aは(\d+)文字以内で入力してください。\z/)
                {code: CODE[:OVER_LENGTH], details: {maxlength: m[1]}}
              when error == "形式が不正です" || error == "が正しくありません。"
                {code: CODE[:INVALID_FORMAT]}
              when error == "設定したいパスコードと確認用のパスコードが一致しません"
                {code: CODE[:NOT_EQUAL_PASSCD]}
              else
                nil # 全てのバリデーションエラーに対応できていないのでスルー.
              end
            end .select(&:present?)

            [key, custom_error_array]

          end .to_h

        end

    end

    # レコード未検出エラー.
    # 「/xxx/:resource_id」系のAPIで「:resource_id」に紐づくデータが存在しないときに利用.
    class RecordNotFoundError < ApiError

      # コンストラクタ
      # key: 未検出データのリクエストパラメーターキー名.
      # value: keyと紐づくvalue.
      # e: ActiveRecord::RecordNotFound オブジェクト.
      def initialize(key, value, e = nil)

        message = e.present? ? e.message : "[レコード未検出エラー]"
        response_status = 1

        super(message, 404, response_status, "[#{key} = #{value}] was not found.")

      end

    end

  end
end
