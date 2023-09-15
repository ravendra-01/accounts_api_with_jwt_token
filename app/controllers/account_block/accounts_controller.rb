module AccountBlock
  class AccountsController < ApplicationController
    include ValidateJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token, only: %i[show update destroy]
    before_action :account_by_token, only: %i[show update destroy]

    def create
      account = find_account

      if account
        return render json: { errors: [
          { account: 'Email ID already in use' }
        ] }, status: :unprocessable_entity
      end

      @account = Account.new(account_params)
      if @account.save
        render json: AccountSerializer.new(@account, meta: { token: encode(@account.id) }).serializable_hash,
               status: :created
      else
        render json: { errors: format_activerecord_errors(@account.errors) },
               status: :unprocessable_entity
      end
    end

    def update
      if @account.update(account_params)
        render json: AccountSerializer.new(@account, meta: { token: encode(@account.id) }).serializable_hash,
               status: :created
      end
    end

    def show
      render json: AccountSerializer.new(@account, meta: { token: encode(@account.id) }).serializable_hash,
               status: :created
    end

    def log_in
      account = find_account
      unless find_account
        return render json: { errors: [
          { account: 'Account Not Found' }
        ] }, status: :unprocessable_entity
      end
      if account.authenticate(account_params[:password])
        render json: AccountSerializer.new(account, meta: { token: encode(find_account.id) }).serializable_hash,
               status: :created
      else
        render json: { errors: [ { account: 'Invalid Password' } ] }, status: :unprocessable_entity
      end
    end

    def destroy
      if @account.destroy
        render json: { message: 'Account Deleted Successfully' }, status: :ok
      end
    end

    private

    def find_account
      Account.find_by(email: account_params[:email])
    end

    def account_by_token
      @account = Account.find @token.id
    end

    def account_params
      params.require(:account).permit(:first_name, :last_name, :phone_number, :email, :password)
    end

    def encode(id)
      CreateJsonWebToken::JsonWebToken.encode id
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end