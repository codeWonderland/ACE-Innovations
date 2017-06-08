function ls(location) {
    location == undefined ? location = document : location = location;
    var divs = location.getElementsByTagName('div');
    for (var i = 0; i < divs.length; i++) {
        console.log('Id: ' + divs[i].getAttribute('id') + ' Class: ' + divs[i].getAttribute('class'));
    }
}
$('#parse').on('click', function() {
    if(document.getElementById("type-of-page").value != "" && document.getElementById("html").value != "") {
        var html = document.getElementById("html");
        var htmlContent = document.getElementById("html-content");
        htmlContent.innerHTML = html.value;
        html.value = "";
        switch(document.getElementById('type-of-page').value) {
            case 'video':
                var tempHTML = "";
                var feature = htmlContent.getElementsByClassName('video-feature')[0];
                tempHTML += buildFeature(feature);
                var sections = htmlContent.getElementsByClassName('video-section');
                for (var i = 0; i < sections.length; i++) {
                    tempHTML += buildSection(sections[i]);
                }
                tempHTML += "<br /><button class=\"btn\" id=\"build-video\" onclick=\"buildVideoHTML()\">Build HTML</button>";
                document.getElementById("input-area").innerHTML = tempHTML;
                break;
            case 'timeline':
                var tempHTML = "";
                var events = htmlContent.getElementsByClassName('events-content')[0].getElementsByTagName('ol')[0].getElementsByTagName('li');
                for (var i = 0; i < events.length; i++) {
                    tempHTML += buildEvent(events[i]);
                }
                tempHTML += "<br /><button class=\"btn\" id=\"build-timeline\" onclick=\"buildTimelineHTML()\">Build HTML</button>";
                document.getElementById("input-area").innerHTML = tempHTML;
                break;
            case 'vert-timeline':
                var tempHTML = "";
                tempHTML += buildVertTimeline(document.getElementsByClassName('container')[0]);
                tempHTML += "<br /><button class=\"btn\" id=\"build-vert-timeline\" onclick=\"buildVertTimelineHTML()\">Build HTML</button>";
                document.getElementById("input-area").innerHTML = tempHTML;
                break;
            default:
                break;
        }
    } else if (document.getElementById("type-of-page").value == "") {
        alert("Select what type of page!");
    } else {
        var html = document.getElementById("html");
        var htmlContent = document.getElementById("html-content");
        htmlContent.innerHTML = html.value;
        html.value = "";
        switch(document.getElementById('type-of-page').value) {
            case 'video':
                var featurehtml = "<div style='height: 610px;' class='feature-video champ-card'><h2>Feature Video</h2>";
                for (var i = 0; i < 4; i++) {
                    if(i % 2 == 0) {
                        featurehtml += "<div style='float: left; margin: 15px; margin-left: 100px' class='video-entry champ-card'>";
                    } else {
                        featurehtml += "<div style='float: left; margin: 15px;' class='video-entry champ-card'>";
                    }
                    if (i == 0) {
                        featurehtml += "<h3>Feature Video Main Video</h3>";
                    } else {
                        featurehtml += "<h3>Feature Video Preview " + i + "</h3>";
                    }
                    featurehtml += "<p style='float: left'>URL:</p><input style='float: left' class='video-url'  /><br /><br />";
                    featurehtml += "<p style='float: left; padding-bottom: 0;'>Thumbnail URL:</p><input style='float: left' class='video-thumb-url'  /><br /><p style='float:left; font-size: 10px; margin-top:0;'>Note: Make sure thumbnail is 16:9</p><br /><br />";
                    featurehtml += "<p style='float: left'>Description:</p><input style='float: left' class='video-description' maxlength='30'  />";
                    featurehtml += "</div>";
                    if(i % 2) {
                        featurehtml+="<br /><br />";
                    }
                }
                featurehtml += "<button style='float: left; margin-left: 20px; margin-top: 10px;' class='btn' onclick='addNewSection(this)'>Add Section</button></div>";
                document.getElementById('input-area').innerHTML = featurehtml;
                break;
            case 'timeline':
                var tempHTML = '<div class="event-entry champ-card">' +
                    '<input maxlength="4"><br /><br />' +
                    '<div><textarea></textarea><br />' +
                    '<button class="btn" onclick="newDetail(this)">Add</button>' +
                    '<button class="btn" onclick="removeDetail(this)" style="margin-left: 5px;">Remove</button>' +
                    '<button class="btn" onclick="moveUp(this)" style="margin-left: 5px;">Up</button>' +
                    '<button class="btn" onclick="moveDown(this)" style="margin-left: 5px;">Down</button>' +
                    '<br /><br /></div>' +
                    '<button class="btn" onclick="addEvent(this)">Add Event</button>' +
                    '<button class="btn" onclick="deleteEvent(this)" style="margin-left: 5px;">Remove Event</button>' +
                    '<button class="btn" onclick="moveUp(this)" style="margin-left: 5px;">Up</button>' +
                    '<button class="btn" onclick="moveDown(this)" style="margin-left: 5px;">Down</button>' +
                    '<button class="btn" onclick="addImage(this)" style="margin-left: 5px;">Add Image</button>' +
                    '</div>' +
                    '<br /><button class=\"btn\" id=\"build-timeline\" onclick=\"buildTimelineHTML()\">Build HTML</button>';
                document.getElementById("input-area").innerHTML = tempHTML;
                break;
            case 'vert-timeline':
                var tempHTML = '<br/><button class="btn" onclick="addCoverPhoto(this)">Add Cover Photo</button><br/>' +
                    '<div class="event-element champ-card"><input class="event-element-header" type="text"><br /><br />' +
                    '<div><textarea class="event-element-point"></textarea>' +
                    '<br/><button class="btn" style="margin-left: 5px" onclick="addElement(this)">Add Detail</button>' +
                    '<button class="btn" style="margin-left: 5px" onclick="removeDetail(this)">Remove Detail</button>' +
                    '<button class="btn" style="margin-left: 5px" onclick="moveUp(this)">Move Up</button>' +
                    '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button>' +
                    '<br/><br/></div>' +
                    '<button class="btn" style="margin-left: 5px" onclick="addTimelineElement(this)">Add Event</button>' +
                    '<button class="btn" style="margin-left: 5px" onclick="deleteEvent(this)">Remove Event</button>' +
                    '<button class="btn" style="margin-left: 5px" onclick="moveUp(this)">Move Up</button>' +
                    '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button></div>';
                document.getElementById("input-area").innerHTML = tempHTML;
                break;
            default:
                break;
        }
    }
});

function buildEvent(event) {
    var html = '<div class="event-entry champ-card">';
    var year = event.getElementsByTagName('h2')[0].innerHTML;
    html += '<input maxlength="4" value="' + year + '"><br /><br />';
    if (event.getElementsByTagName('img').length != 0) {
        html += '<div><h3 style="float: left; margin-bottom: 0;">Image Address: </h3><input style="margin-bottom: 0" class="timeline-image"' +
            ' value="' + event.getElementsByTagName('img')[0].getAttribute('src') + '"><br />' +
            '<button style="clear: left; float: left; margin-top: 0" class="btn" onclick="deleteEvent(this)">Remove Image</button><br /><br /><br /></div>';
    }
    var points = event.getElementsByTagName('p');
    for(var i = 0; i < points.length; i++) {
        html += '<div><textarea>' + points[i].innerHTML + '</textarea>'
            + '<br /><button class="btn" onclick="newDetail(this)">Add</button>' +
            '<button class="btn" onclick="removeDetail(this)" style="margin-left: 5px;">Remove</button>' +
            '<button class="btn" onclick="moveUp(this)" style="margin-left: 5px;">Up</button>' +
            '<button class="btn" onclick="moveDown(this)" style="margin-left: 5px;">Down</button>' +
            '<br /><br /></div>';
    }
    html += '<button class="btn" onclick="addEvent(this)">Add Event</button>' +
        '<button class="btn" onclick="deleteEvent(this)" style="margin-left: 5px;">Remove Event</button>' +
        '<button class="btn" onclick="moveUp(this)" style="margin-left: 5px;">Up</button>' +
        '<button class="btn" onclick="moveDown(this)" style="margin-left: 5px;">Down</button>' +
        '<button class="btn" onclick="addImage(this)" style="margin-left: 5px;">Add Image</button>' +
        '</div>';
    return html;
}

function moveUp(button) {
    var prevElement = $(button.parentElement).prev();
    if($(button.parentElement).prop("tagName") == $(prevElement).prop("tagName"))
        $(button.parentElement).detach().insertBefore(prevElement);
}

function moveSectionUp(button) {
    var prevElement = $(button.parentElement).prev();
    if($(prevElement).hasClass('section-video')) {
        $(button.parentElement).detach().insertBefore(prevElement);
    }
}

function moveDown(button) {
    var nextElement = $(button.parentElement).next();
    if($(button.parentElement).prop("tagName") == $(nextElement).prop("tagName"))
        $(button.parentElement).detach().insertAfter(nextElement);
}

function addEvent(button) {
    $('<div class="event-entry champ-card">' +
        '<input maxlength="4"><br /><br />' +
        '<div><textarea></textarea><br />' +
        '<button class="btn" onclick="newDetail(this)">Add</button>' +
        '<button class="btn" onclick="removeDetail(this)" style="margin-left: 5px;">Remove</button>' +
        '<button class="btn" onclick="moveUp(this)" style="margin-left: 5px;">Up</button>' +
        '<button class="btn" onclick="moveDown(this)" style="margin-left: 5px;">Down</button>' +
        '<br /><br /></div>' +
        '<button class="btn" onclick="addEvent(this)">Add Event</button>' +
        '<button class="btn" onclick="deleteEvent(this)" style="margin-left: 5px;">Remove Event</button>' +
        '<button class="btn" onclick="moveUp(this)" style="margin-left: 5px;">Up</button>' +
        '<button class="btn" onclick="moveDown(this)" style="margin-left: 5px;">Down</button>' +
        '<button class="btn" onclick="addImage(this)" style="margin-left: 5px;">Add Image</button>' +
        '</div>').insertAfter(button.parentElement);
}

function addImage(button) {
    if (button.parentElement.getElementsByTagName('h3').length == 0) {
        $('<div><h3 style="float: left; margin-bottom: 0;">Image Address: </h3><input style="margin-bottom: 0" class="timeline-image"><br />' +
            '<button style="clear: left; float: left; margin-top: 0" class="btn" onclick="deleteEvent(this)">Remove Image</button><br /><br /><br /></div>').insertAfter($(button.parentElement.getElementsByTagName('input')[0]).next().next());
    }
}

function deleteEvent(button) {
    $(button.parentElement).remove();
}

function newDetail(button) {
    $('<div><textarea></textarea><br />' +
        '<button class="btn" onclick="newDetail(this)">Add</button>' +
        '<button class="btn" onclick="removeDetail(this)" style="margin-left: 5px;">Remove</button>' +
        '<button class="btn" onclick="moveUp(this)" style="margin-left: 5px;">Up</button>' +
        '<button class="btn" onclick="moveDown(this)" style="margin-left: 5px;">Down</button>' +
        '<br /><br /></div>').insertAfter(button.parentElement);
}

function removeDetail(button) {
    if(button.parentElement.parentElement.getElementsByTagName('textarea').length >= 2) {
        $(button.parentElement).remove();
    }
}

function buildTimelineHTML() {
    var timelineHTML = document.getElementById("timeline-html");
    var events = document.getElementsByClassName('event-entry');
    var tempHTML = "";
    tempHTML += "<ol>";
    for (var i = 0; i < events.length; i++) {
        var currentEvent = events[i].getElementsByTagName('input')[0].value;
        if(i == 0) {
            tempHTML += '<li><a href=\"#0\" data-date=\"01/01/' + currentEvent + '\" class=\"selected\">' + currentEvent + '</a></li>';
        } else {
            tempHTML += '<li><a href=\"#0\" data-date=\"01/01/' + currentEvent + '\">' + currentEvent + '</a></li>';
        }
    }
    tempHTML += '</ol><span class=\"filling-line\" aria-hidden=\"true\"></span>';
    timelineHTML.getElementsByClassName('events')[0].innerHTML = tempHTML;
    tempHTML = "";
    for (var i = 0; i < events.length; i++) {
        var currentEvent = events[i].getElementsByTagName('input')[0].value;
        if (i == 0) {
            tempHTML += '<li class=\"selected\" data-date=\"01/01/' + currentEvent + '\">';
        } else {
            tempHTML += '<li data-date=\"01/01/' + currentEvent + '\">';
        }
        tempHTML += '<h2>' + currentEvent + '</h2>';
        if(events[i].getElementsByTagName('h3').length != 0) {
            tempHTML += '<img src="' + events[i].getElementsByTagName('input')[1].value + '" style="width: 100%; height: auto;" /><br /><br />'
        }
        var points = events[i].getElementsByTagName('textarea');
        for (var j = 0; j < points.length; j++) {
            tempHTML += '<p>' + points[j].value + '</p><br />'
        }
        tempHTML += '</li>';
    }
    timelineHTML.getElementsByClassName('events-content')[0].getElementsByTagName('ol')[0].innerHTML = tempHTML;
    $("<br /><br /><textarea id=\"output-html\"></textarea>").insertAfter('#build-timeline');
    document.getElementById("output-html").value = timelineHTML.innerHTML;
}

function buildVideoHTML() {
    var videoHTML = document.getElementById('video-page-html');
    var feats = videoHTML.getElementsByClassName('video-feature')[0].getElementsByClassName('feat-objects');
    var featsConContent = document.getElementsByClassName('feature-video')[0].getElementsByClassName('video-entry');
    for (var i = 0; i < 4; i++) {
        feats[i].innerHTML = '<p class="video-url">' + featsConContent[i].getElementsByClassName('video-url')[0].value + '</p>' +
            '<p class="thumbnail-url">' + featsConContent[i].getElementsByClassName('video-thumb-url')[0].value + '</p>' +
            '<p class="video-description">' + featsConContent[i].getElementsByClassName('video-description')[0].value + '</p>';
    }
    var htmlOutput = videoHTML.innerHTML;
    var sections = document.getElementsByClassName('section-video');
    for(var i = 0; i < sections.length; i++) {
        htmlOutput += '<div class="video-section champ-card">' +
            '<div class="section-panel-left">' +
            '<h2>' + sections[i].getElementsByClassName('section-title')[0].value + '</h2><br />' +
            '<div class="video-section-main video"></div>' +
            '</div>' +
            '<div class="section-panel-right"></div>';
        var entries = sections[i].getElementsByClassName('video-entry');
        for(var j = 0; j < 4; j++) {
            htmlOutput += '<div class="video-section-object">' +
                '<p class="video-url-section">' + entries[j].getElementsByClassName('video-url')[0].value + '</p>' +
                '<p class="thumbnail-url-section">' + entries[j].getElementsByClassName('video-thumb-url')[0].value + '</p>' +
                '<p class="video-description-section">' + entries[j].getElementsByClassName('video-description')[0].value + '</p>' +
                '</div>';
        }
        htmlOutput += '</div><br /><br />';
    }
    
    
    $("<br /><br /><textarea id=\"output-html\"></textarea>").insertAfter('#build-video');
    document.getElementById("output-html").value = htmlOutput;
}

function buildFeature(feature) {
    var featurehtml = "<div style='height: 610px;' class='feature-video champ-card'><h2>Feature Video</h2>";
    objects = feature.getElementsByClassName('feat-objects');
    for (var i = 0; i < 4; i++) {
        if(i % 2 == 0) {
            featurehtml += "<div style='float: left; margin: 15px; margin-left: 100px' class='video-entry champ-card'>";
        } else {
            featurehtml += "<div style='float: left; margin: 15px;' class='video-entry champ-card'>";
        }
        if (i == 0) {
            featurehtml += "<h3>Feature Video Main Video</h3>";
        } else {
            featurehtml += "<h3>Feature Video Preview " + i + "</h3>";
        }
        var vidurl = objects[i].getElementsByClassName('video-url')[0].innerHTML;
        var thumb = objects[i].getElementsByClassName('thumbnail-url')[0].innerHTML;
        var descript = objects[i].getElementsByClassName('video-description')[0].innerHTML;
        featurehtml += "<p style='float: left'>URL:</p><input style='float: left' class='video-url' value='" + vidurl + "' /><br /><br />";
        featurehtml += "<p style='float: left; padding-bottom: 0;'>Thumbnail URL:</p><input style='float: left' class='video-thumb-url' value='" + thumb + "' /><br /><p style='float:left; font-size: 10px; margin-top:0;'>Note: Make sure thumbnail is 16:9</p><br /><br />";
        featurehtml += "<p style='float: left'>Description:</p><input style='float: left' class='video-description' maxlength='30' value='" + descript + "' />";
        featurehtml += "</div>";
        if(i % 2) {
            featurehtml+="<br /><br />";
        }
    }
    featurehtml += "<button style='float: left; margin-left: 20px; margin-top: 10px;' class='btn' onclick='addNewSection(this)'>Add Section</button></div>";
    return featurehtml;
}

function buildSection(section) {
    var sectionhtml = "<div style='height: 650px;' class='section-video champ-card'><h2>Video Section</h2>";
    sectionhtml += "<p style='float: left'>Section Title</p><input style='float: left' class='section-title' value='" + section.getElementsByTagName('h2')[0].innerHTML + "' /><br /><br />";
    objects = section.getElementsByClassName('video-section-object');
    for (var i = 0; i < 4; i++) {
        if(i % 2 == 0) {
            sectionhtml += "<div style='float: left; margin: 15px; margin-left: 100px' class='video-entry champ-card'>";
        } else {
            sectionhtml += "<div style='float: left; margin: 15px;' class='video-entry champ-card'>";
        }
        if (i == 0) {
            sectionhtml += "<h3>Section Video Main Video</h3>";
        } else {
            sectionhtml += "<h3>Section Video Preview " + i + "</h3>";
        }
        var vidurl = objects[i].getElementsByClassName('video-url-section')[0].innerHTML;
        var thumb = objects[i].getElementsByClassName('thumbnail-url-section')[0].innerHTML;
        var descript = objects[i].getElementsByClassName('video-description-section')[0].innerHTML;
        sectionhtml += "<p style='float: left'>URL:</p><input style='float: left' class='video-url' value='" + vidurl + "' /><br /><br />";
        sectionhtml += "<p style='float: left; padding-bottom: 0;'>Thumbnail URL:</p><input style='float: left' class='video-thumb-url' value='" + thumb + "' /><br /><p style='float:left; font-size: 10px; margin-top:0;'>Note: Make sure thumbnail is 16:9</p><br /><br />";
        sectionhtml += "<p style='float: left'>Description:</p><input style='float: left' class='video-description' maxlength='30' value='" + descript + "' />";
        sectionhtml += "</div>";
        if(i % 2) {
            sectionhtml+="<br /><br />";
        }
    }
    sectionhtml += "<button style='float: left; margin-left: 20px; margin-top: 10px;' class='btn' onclick='addNewSection(this)'>Add Section</button>";
    sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='deleteEvent(this)'>Remove Section</button>";
    sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='moveSectionUp(this)'>Move Up</button>";
    sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='moveDown(this)'>Move Down</button></div>";
    return sectionhtml;
}

function addNewSection(button) {
    var sectionhtml = "<div style='height: 650px;' class='section-video champ-card'><h2>Video Section</h2>";
    sectionhtml += "<p style='float: left'>Section Title</p><input style='float: left' class='section-title' /><br /><br />";
    for (var i = 0; i < 4; i++) {
        if(i % 2 == 0) {
            sectionhtml += "<div style='float: left; margin: 15px; margin-left: 100px' class='video-entry champ-card'>";
        } else {
            sectionhtml += "<div style='float: left; margin: 15px;' class='video-entry champ-card'>";
        }
        if (i == 0) {
            sectionhtml += "<h3>Section Video Main Video</h3>";
        } else {
            sectionhtml += "<h3>Section Video Preview " + i + "</h3>";
        }
        sectionhtml += "<p style='float: left'>URL:</p><input style='float: left' class='video-url' /><br /><br />";
        sectionhtml += "<p style='float: left; padding-bottom: 0;'>Thumbnail URL:</p><input style='float: left' class='video-thumb-url' /><br /><p style='float:left; font-size: 10px; margin-top:0;'>Note: Make sure thumbnail is 16:9</p><br /><br />";
        sectionhtml += "<p style='float: left'>Description:</p><input style='float: left' class='video-description' maxlength='30' />";
        sectionhtml += "</div>";
        if(i % 2) {
            sectionhtml+="<br /><br />";
        }
    }
    sectionhtml += "<button style='float: left; margin-left: 20px; margin-top: 10px;' class='btn' onclick='addNewSection(this)'>Add Section</button>";
    sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='deleteEvent(this)'>Remove Section</button>";
    sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='moveSectionUp(this)'>Move Up</button>";
    sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='moveDown(this)'>Move Down</button></div>";
    $(sectionhtml).insertAfter($(button.parentElement));
}

function buildVertTimeline(container) {
    var tempHTML = "";
    if(document.getElementsByClassName('vert-timeline-image').length != 0) {
        tempHTML += '<br/><div><h3 style="float: left; margin-bottom: 0;">Image Address: </h3><input style="margin-bottom: 0; margin-top: 15px;" ' +
            'value="' + document.getElementsByClassName('vert-timeline-image')[0].getAttribute('src') + '" class="timeline-image"><br />' +
            '<button style="clear: left; float: left; margin-top: 0" class="btn" onclick="removeCoverPhoto(this)">Remove Image</button><br /><br /></div>'
    } else {
        tempHTML += '<br/><button class="btn" onclick="addCoverPhoto(this)">Add Cover Photo</button><br/>';
    }
    var events = container.getElementsByClassName('timeline-item');
    for (var i = 0; i < events.length; i++) {
        tempHTML += '<div class="event-element champ-card"><input class="event-element-header" type="text" value="' + events[i].getAttribute('data-year') + '"><br /><br />';
        var points = events[i].getElementsByTagName('li');
        for (var j = 0; j < points.length; j++) {
            console.log(points[j].innerHTML);
            tempHTML += '<div><textarea class="event-element-point">' + points[j].innerHTML + '</textarea>' +
                '<br/><button class="btn" style="margin-left: 5px" onclick="addElement(this)">Add Detail</button>' +
                '<button class="btn" style="margin-left: 5px" onclick="removeDetail(this)">Remove Detail</button>' +
                '<button class="btn" style="margin-left: 5px" onclick="moveUp(this)">Move Up</button>' +
                '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button>' +
                '<br/><br/></div>';
        }
        tempHTML += '<button class="btn" style="margin-left: 5px" onclick="addTimelineElement(this)">Add Event</button>' +
            '<button class="btn" style="margin-left: 5px" onclick="deleteEvent(this)">Remove Event</button>' +
            '<button class="btn" style="margin-left: 5px" onclick="moveUp(this)">Move Up</button>' +
            '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button></div>';
    }
    return tempHTML;
}

function addCoverPhoto(button) {
    if (button.parentElement.getElementsByTagName('h3').length == 0) {
        $('<div><h3 style="float: left; margin-bottom: 0;">Image Address: </h3><input style="margin-bottom: 0; margin-top: 15px;" class="timeline-image"><br />' +
            '<button style="clear: left; float: left; margin-top: 0" class="btn" onclick="removeCoverPhoto(this)">Remove Image</button><br /><br /></div>').insertBefore(button);
        button.remove();
    }
}

function removeCoverPhoto(button) {
    $('<button class="btn" onclick="addCoverPhoto(this)">Add Cover Photo</button>').insertBefore(button.parentElement);
    button.parentElement.remove();
}

function addTimelineElement(button) {
    $('<div class="event-element champ-card"><input class="event-element-header" type="text"><br /><br />' +
        '<div><textarea class="event-element-point"></textarea>' +
        '<br/><button class="btn" style="margin-left: 5px" onclick="addElement(this)">Add Detail</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="removeDetail(this)">Remove Detail</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="moveUp(this)">Move Up</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button>' +
        '<br/><br/></div>' +
        '<button class="btn" style="margin-left: 5px" onclick="addTimelineElement(this)">Add Event</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="deleteEvent(this)">Remove Event</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="moveUp(this)">Move Up</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button></div>').insertAfter(button.parentElement);
}

function addElement(button) {
    $('<div><textarea class="event-element-point"></textarea>' +
        '<br/><button class="btn" style="margin-left: 5px" onclick="addElement(this)">Add Detail</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="removeDetail(this)">Remove Detail</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="moveUp(this)">Move Up</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button>' +
        '<br/><br/></div>').insertAfter(button.parentElement);
}

function buildVertTimelineHTML() {
    var tempHTML = "";
    if (document.getElementsByClassName('timeline-image').length != 0) {
        tempHTML += '<img style="width: 100%; height: auto;" class="vert-timeline-image" src="' + document.getElementsByClassName('timeline-image')[0].value + '" />';
    }
    tempHTML += '<div class="container">';
    var events = document.getElementsByClassName('event-element');
    for (var i = 0; i < events.length; i++) {
        tempHTML += '<div class="timeline-item" data-year="' + events[i].getElementsByClassName('event-element-header')[0].value + '">' +
            '<div class="time-card">' +
            '<ul>';
        var points = events[i].getElementsByClassName('event-element-point');
        for (var j = 0; j < points.length; j++) {
            tempHTML += '<li>' + points[j].value + '</li>';
        }
        tempHTML += '</ul></div></div>';
    }
    tempHTML += '</div>';
    $("<br /><br /><textarea id=\"output-html\"></textarea>").insertAfter('#build-vert-timeline');
    document.getElementById("output-html").value = tempHTML;
}/**
 * Created by aliceeaster on 6/8/17.
 */
