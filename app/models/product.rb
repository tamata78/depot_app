class Product < ActiveRecord::Base
  #各項目の必須チェック
  validates :title, :description, :image_url, presence: true
  #数値かつ指定数値以上かをチェック
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  #他の商品名と重複しない名称かをチェック
  validates :title, uniqueness: true
  #適切な画像のURLかをチェック
  validates :image_url, allow_blank: true, format: {
    with: %r{.(gif|jpg|png)\z}i,
    message: 'はGIF, JPG, PNG画像のURLでなければなりません'
  }
  #商品名が１０文字以上の長さかをチェック
  validates :title, length: {minimum: 10}
end
