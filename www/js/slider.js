$(document).ready(function() {
        let isDragging = false;
        const container = $('#map1_container').parent();
        const map1Container = $('#map1_container');
        const map2Container = $('#map2_container');
        const divider = $('#divider');
        
        // Divider position update
        function updatePosition(clientX) {
          const rect = container[0].getBoundingClientRect();
          const x = clientX - rect.left;
          const percentage = Math.max(0, Math.min(100, (x / rect.width) * 100));
          
          map1Container.css('clip-path', `inset(0 ${100 - percentage}% 0 0)`);
          map2Container.css('clip-path', `inset(0 0 0 ${percentage}%)`);
          divider.css('left', percentage + '%');
        }
        
        divider.on('mousedown', function(e) {
          isDragging = true;
          e.preventDefault();
        });
        
        $(document).on('mousemove', function(e) {
          if (isDragging) {
            updatePosition(e.clientX);
          }
        });
        
        $(document).on('mouseup', function() {
          isDragging = false;
        });
        
        // Touch events
        divider.on('touchstart', function(e) {
          isDragging = true;
          e.preventDefault();
        });
        
        $(document).on('touchmove', function(e) {
          if (isDragging) {
            updatePosition(e.touches[0].clientX);
          }
        });
        
        $(document).on('touchend', function() {
          isDragging = false;
        });
      });