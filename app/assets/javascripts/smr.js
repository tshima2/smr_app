"use strict";

$(function () {
    $(".clear-button").on("click", function () {
        clearForm(this.form);
    });

    function clearForm (form) {
        $(form)
            .find("input, select, textarea")
            .not(":button, :submit, :reset, :hidden")
            .val("")
            .prop("checked", false)
            .prop("selected", false)
        ;

       $(form).find(":radio").filter("[data-default]").prop("checked", true);
    }
});
    
function site_link_copy(){
  let divTag = document.getElementById('request_url');
  let range = document.createRange();
  range.selectNodeContents(divTag);
  let selection = document.getSelection();
  selection.removeAllRanges();
  selection.addRange(range);

  document.execCommand('copy');
  alert('サイトURLをクリップボードにコピーしました');
  selection.removeAllRanges();
};