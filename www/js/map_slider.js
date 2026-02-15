Shiny.addCustomMessageHandler('initSlider', function(message) {
  var container = document.getElementById('map-container');
  var divider = document.getElementById('slider-divider');
  var map2Wrapper = document.getElementById('map2-wrapper');
  var isDragging = false;
  
  function updatePosition(x) {
    var rect = container.getBoundingClientRect();
    var position = ((x - rect.left) / rect.width) * 100;
    position = Math.max(0, Math.min(100, position));
    
    divider.style.left = position + '%';
    map2Wrapper.style.clipPath = 'inset(0 ' + (100 - position) + '% 0 0)';
    
    Shiny.setInputValue('slider_pos', position);
  }
  
  divider.addEventListener('mousedown', function(e) {
    isDragging = true;
    e.preventDefault();
  });
  
  document.addEventListener('mousemove', function(e) {
    if (isDragging) {
updatePosition(e.clientX);
    }
  });
  
  document.addEventListener('mouseup', function() {
    isDragging = false;
  });
  
  container.addEventListener('click', function(e) {
    if (!isDragging && e.target === container) {
updatePosition(e.clientX);
    }
  });
});