class ApplicationController < ActionController::API
  # --- ここから （意図的に処理時間を伸ばすための記述） ---
  before_action :fake_load

  def fake_load
    sleep(1.5)
  end
  # --- ここまで ---
end
