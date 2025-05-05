/*******************************************************************************
*                                                                              *
*                                                                              *
*                 A U T H E N T I C A T I O N  F U N C T I O N S               *
*                                                                              *
*                                                                              *
********************************************************************************/

// Ask the API for user status, if logged it returns user info
function checkLoginStatus() {
    $.ajax({
        url: '/auth/logged',
        type: 'GET',
        dataType: 'json',
        success: function(data, statis, xhr) {
            // User is logged in since we received valid JSON
            var output = JSON.stringify(xhr);
            console.log('User is logged in:', data);
            // Set current user
            CURRENT_USER = data;
            // Update UI
            toggleLoginInfo();
            // For the langing page
            if ( $('#fb-login-block').length ) {
                toggleFBLoginBlock();
            }
        },
        error: function(xhr, status, error) {
            var output = JSON.stringify(xhr);
            console.log(`User is not logged in, working with limited actions: ${output}`);
            CURRENT_USER = {};
        }
    });
}


// Check if the user is logged in
function setupLoginCheck(interval) {
    // Run immediately on page load
    console.log("Checking login status for user");
    checkLoginStatus();

    // Then run every interval minutes
    setInterval(checkLoginStatus, interval * 60 * 1000);
      
    // Optional: Also check when the window regains focus
    $(window).focus(function() {
        checkLoginStatus();
    });
}

// Toggle login controls
function toggleLoginInfo() {
    if ( !isEmpty(CURRENT_USER) ) {
        // Don't update user controls if we already did it
        if ( !$('#user_info').hasClass("logged") ) {
            var concat = $("#user_info").html() + " " + CURRENT_USER.name;
            $('#user_info').html(concat);
            $('#login_button').hide();
            $('#user_info').addClass("logged");
            $('#user_info').show();
            $('#user_logout').show();
        }
    } else {
        $('#user_info').removeClass("logged");
        $('#login_button').show();
        $('#user_info').hide();
        $('#user_logout').hide();
    }
}

// Checks if a object is empty
function isEmpty(obj) {
    // Check if obj is null or not an object
    if (obj === null || typeof obj !== 'object') {
        throw new TypeError('Input must be an object');
    }

    // Check if object has any own enumerable properties
    return Object.keys(obj).length === 0;
}

// Function to load reactions for a single candidate
function loadCandidateReactions(candidateId) {
    $.ajax({
        url: `/candidates/${candidateId}/reactions`,
        method: 'GET',
        success: function(data) {
            // Update reaction counts
            $('#like-count-' + candidateId).text(data.like_count || 0);
            $('#dislike-count-' + candidateId).text(data.dislike_count || 0);
            $('#danger-count-' + candidateId).text(data.danger_count || 0);
        },
        error: function(err) {
            console.error('Error loading reactions for candidate', candidateId, err);
        }
    });
}

function toggleFBLoginBlock() {
    console.log("en tooggle: " + JSON.stringify(CURRENT_USER));
    if ( !isEmpty(CURRENT_USER) ) {
        console.log("Logueado, ocultando botón de fb");
        $('#fb-login-block').hide();
    }
}
