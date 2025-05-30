/*******************************************************************************
*                                                                              *
*                                                                              *
*            P A G I N A T I O N  &  S E A R C H  F U N C T I O N S            *
*                                                                              *
*                                                                              *
********************************************************************************/


// Search functionality
function performSearch() {
    const searchTerm = $('#searchInput').val().toLowerCase();
      
    // If search term is empty, show all rows
    if (searchTerm === '') {
        rows.removeClass('filtered');
    } else {
    // Loop through all rows and check if they match the search
        rows.each(function() {
            const $row = $(this);
            const fullname = $row.data('fullname').toLowerCase();
            const position = $row.data('position').toLowerCase();
            const state = $row.data('state').toLowerCase();
            const matter = $row.data('matter').toLowerCase();
            const ine_section = $row.data('ine_section').toLowerCase();
          
            // Check if any of the data contains the search term
            if (fullname.includes(searchTerm) || 
                position.includes(searchTerm) || 
                matter.includes(searchTerm) || 
                state.includes(searchTerm)) {
                    $row.removeClass('filtered');
                } else {
                    $row.addClass('filtered');
                }
        });
    }
      
    // Reset to first page and display appropriate rows
    currentPage = 1;
    displayRows();
}

// Function to display the appropriate rows for the current page
function displayRows() {
    rows.hide();
    const start = (currentPage - 1) * rowsPerPage;
    const end = start + rowsPerPage;
      
    // Only show visible rows based on both pagination and search
    const visibleRows = rows.filter(':not(.filtered)');
    visibleRows.slice(start, end).show();
      
    // Update pagination UI
    updatePagination();
}


// Function to update pagination controls
function updatePagination() {
    const visibleRows = rows.filter(':not(.filtered)').length;
    const filteredPagesCount = Math.ceil(visibleRows / rowsPerPage);

    const pagination = $('#pagination');
    pagination.empty();

    // Previous button
    pagination.append(`
        <li class="page-item ${currentPage === 1 ? 'disabled' : ''}">
          <a class="page-link" href="#" data-page="${currentPage - 1}">Previous</a>
        </li>
    `);

    // Page numbers
    for (let i = 1; i <= filteredPagesCount; i++) {
        pagination.append(`
            <li class="page-item ${currentPage === i ? 'active' : ''}">
            <a class="page-link" href="#" data-page="${i}">${i}</a>
          </li>
        `);
    }

    // Next button
    pagination.append(`
        <li class="page-item ${currentPage === filteredPagesCount ? 'disabled' : ''}">
          <a class="page-link" href="#" data-page="${currentPage + 1}">Next</a>
        </li>
    `);

    // Add click event for pagination links
    $('.page-link').click(function(e) {
        e.preventDefault();
        const page = parseInt($(this).data('page'));

        // Only navigate if it's a valid page
        if (page >= 1 && page <= filteredPagesCount && page !== currentPage) {
          currentPage = page;
          displayRows();
        }
    });
}

// Filter by matter
function matterFilter(matter) {
    $('#searchInput').val(matter);
    performSearch();
}



