$(function () {

  $('a.lang-selector').click(function (event) {
    var langRegex = /\/(fa|en)\//;
    var matches = langRegex.exec($(this).attr('href'));

    if (matches[1]) { $.cookie("languagePref", matches[1], {path: "/"}); }
  });

});
