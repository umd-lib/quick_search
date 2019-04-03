$(document).ready(function() {

    // remove some generic library website template content from DOM
    $('#utility-search').remove();
    $('#search-toggle').remove();
    
});

//  This handles the highlighting of modules when a result types quide link is clicked
$(document).on('click', '.result-types a', function () {
    
    // Grab the hash value
    var hash = this.hash.substr(1);

    // Remove any active highlight
    $('.result-types-highlight').remove();

    // Add the highlight
    $('#' + hash + ' h2').prepend('<span class="result-types-highlight"><i class="fa fa-angle-double-right highlight"></i>&nbsp;</span>');
    
    // Fade it away and then remove it.
    $('#' + hash + ' .highlight').delay( 3000 ).animate({backgroundColor: 'transparent'}, 500 );
    setTimeout(function() {
        $('#' + hash + ' .result-types-highlight').remove();
    }, 3550);
});
