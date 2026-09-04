class Support::StaticPagesController < ApplicationController
  skip_before_action :require_login, only: [:list, :howto, :terms, :policy]

  def list
  end

  # 資料関係
  def howto
  end

  def terms
  end

  def policy
  end
end
