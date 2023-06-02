jQuery(document).on("turbolinks:load", function() {
  $(".company_table_tr").on('click', function() {
      window.location = $(this).data("href");
  });
});