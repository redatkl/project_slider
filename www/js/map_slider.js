$(document).on('shiny:idle', function() {
  setTimeout(function() {
    $('.map-slider-container').each(function() {
      var container = $(this);
      var ns = container.data('ns');
      var leftContainer = container.find('.map-left-container');
      var rightContainer = container.find('.map-right-container');
      var slider = container.find('.map-slider-divider');
      var isDragging = false;
      
      slider.on('mousedown touchstart', function(e) {
        isDragging = true;
        e.preventDefault();
      });
      
      $(document).on('mousemove touchmove', function(e) {
        if (isDragging) {
          var clientX = e.type === 'touchmove' ? e.touches[0].clientX : e.clientX;
          var containerOffset = container.offset().left;
          var containerWidth = container.width();
          var mouseX = clientX - containerOffset;
          var percentage = (mouseX / containerWidth) * 100;
          percentage = Math.max(10, Math.min(90, percentage));
          
          leftContainer.css('width', percentage + '%');
          rightContainer.css('width', (100 - percentage) + '%');
          slider.css('left', percentage + '%');
          
          if (window.mapLeft) window.mapLeft.invalidateSize();
          if (window.mapRight) window.mapRight.invalidateSize();
        }
      });
      
      $(document).on('mouseup touchend', function() {
        isDragging = false;
      });
    });
  }, 500);
});