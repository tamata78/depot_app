require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "product attribute must not be empty" do
    product = Product.new
    # productモデルが妥当でないかをチェック
    assert product.invalid?
    # ハッシュで指定した項目のエラー有無チェック
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My Book Title",
                                         description: "yyy",
                                         image_url: "zzz.jpg")
    # 価格が-1の場合,エラー
    product.price = -1;
    assert product.invalid?
    # joinはエラーが複数存在した場合、;区切りで結合するメソッド
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')

    # 価格が0の場合,エラー
    product.price = 0;
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')

    # 価格が1の場合,正常
    product.price = 1;
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: "My Book Title",
                                         description: "yyy",
                                         price: 1,
                                         image_url: image_url)
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
                    http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more}

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a uniq title" do
        #products(:ruby)においてフィクスチャにアクセス
        product = Product.new(title: products(:ruby).title,
                                         description: "yyy",
                                         price: 1,
                                         image_url: "fred.jpg")
        assert !product.save
        assert_equal "has already been taken",
                            product.errors[:title].join('; ')
  end

  test "product title is more than 10 character " do
    product = Product.new(title: products(:ruby).title,
                                         description: "yyy",
                                         price: 1,
                                         image_url: "fred.jpg")

    assert product.invalid?, "#{product.title} shouldn't be valid"
  end

end


