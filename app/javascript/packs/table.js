jQuery(document).on("turbolinks:load", function() {
  $(".table_tr_link").on('click', function() {
      window.location = $(this).data("href");
  });
});