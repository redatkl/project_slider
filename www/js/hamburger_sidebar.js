 $(document).ready(function() {
        $('#sidebarToggle').click(function() {
          $('#sidebar').toggleClass('active');
          $('#mainContent').toggleClass('sidebar-active');
          $(this).toggleClass('active');
        });
        
        // Close sidebar when clicking outside on mobile
        $(document).click(function(event) {
          if (!$(event.target).closest('#sidebar, #sidebarToggle').length) {
            if ($('#sidebar').hasClass('active')) {
              $('#sidebar').removeClass('active');
              $('#mainContent').removeClass('sidebar-active');
              $('#sidebarToggle').removeClass('active');
            }
          }
        });
      });