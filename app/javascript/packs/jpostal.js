jQuery(document).on("turbolinks:load", function() {
  $('#office_postcode').jpostal({
    postcode : [
      // 取得する郵便番号のテキストボックスをidで指定
      '#office_postcode'
    ],
    address: {
      // %3 => 都道府県、 %4 => 市区町村 %5 => 町域
      // それぞれを表示するコントロールをidで指定
      "#office_prefecture_code"  : "%3",
      "#office_address_city"   : "%4%5",
    }
  });
});