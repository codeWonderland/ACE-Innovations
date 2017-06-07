# This is a function that should be used for every large project to emulate the ls function in terminal
ls = (location = document) ->
  divs = location.getElementsByTagName('div')
  console.log "Id: #{div.getAttribute('id')}, Class: #{div.getAttribute('class')}" for div in divs
  return

#this function is meant to take the html in the page builder text box
#and parse it appropriately when the parse button is clicked
$('#parse').on "click", ->
  pageType = document.getElementById("type-of-page")
  html = document.getElementById("html")
  htmlContent = document.getElementById("html-content")
  #if the pageType was selected and the textarea is not empty we will parse the data
  if pageType.value? and html.value?
#move the html from the text box to a hidden div then empty the text box
    htmlContent.innerHTML = html.value
    html.value = ""
    tempHTML = ""
    #depending on what type of page is selected the html will be parsed differently
    switch pageType.value
      when "video"
        feature = htmlContent.getElementsByClassName('video-feature')[0]
        tempHTML += buildFeature(feature)
        sections = htmlContent.getElementsByClassName('video-section')
        tempHTML += buildSection(section) for section in sections
        tempHTML += "<br /><button class='btn' id='build-video' onclick='buildVideoHTML()'>Build HTML</button>"
      when "timeline"
        events = htmlContent.getElementsByClassName('events-content')[0].getElementsByTagName('ol')[0].getElementsByTagName('li')
        tempHTML += buildEvent(event) for event in events
        tempHTML += "<br /><button class='btn' id='build-timeline' onclick='buildTimelineHTML()'>Build HTML</button>"
      when "vert-timeline"
        tempHTML += buildVertTimeline(document.getElementsByClassName('container')[0])
        tempHTML += "<br /><button class='btn' id='build-vert-timeline' onclick='buildVertTimelineHTML()'>Build HTML</button>"
      else break
    #after the html from each section is translated appropriately, this will be injected directly into the page
    document.getElementById("input-area").innerHTML = tempHTML
    return
#if the page type is not selected, therefore the value is null
  else if not pageType?
    alert "Select what type of page!"
    return
#if we have reached this state then the page type is selected but the textarea is empty
#therefore an empty template of the selection will be injected in to the page
  else
    htmlContent.innerHTML = html.value
    html.value = ""
    tempHTML = ""
    switch pageType.value
      when "video"
        tempHTML += "<div style='height: 610px;' class='feature-video champ-card'><h2>Feature Video</h2>"
        #there are four videos for each section of the feature video builder and are organized as follows:
        for i in [0...4]
#the first and third element will be pushed further over so that there will be two rows
#by two columns of entry forms
          if not i % 2
            tempHTML += "<div style='float: left; margin: 15px; margin-left: 100px;' class='video-entry champ-card'>"
          else
            tempHTML += "<div style'float: left; margin: 15px;' class='video-entry champ-card'>"
          #if this is the first element then it will be known as the main video
          if not i
            tempHTML += "<h3>Feature Video Main Video</h3>"
#if this is not the first video then it will be labeled by it's order in the list
          else
            tempHTML += "<h3>Feature Video Preview #{i}</h3>"
          tempHTML += "<p style='float: left'>URL:</p><input style='float: left' class='video-url'  /><br /><br />" +
              "<p style='float: left; padding-bottom: 0;'>Thumbnail URL:</p><input style='float: left' class='video-thumb-url'  />" +
              "<br /><p style='float:left; font-size: 10px; margin-top:0;'>Note: Make sure thumbnail is 16:9</p><br /><br />" +
              "<p style='float: left'>Description:</p><input style='float: left' class='video-description' maxlength='30'  />"
          "</div>"
          #after every other element there will be break points to create a second row of entry forms
          if i % 2
            tempHTML += "<br/><br/>"
        tempHTML += "<button style='float: left; margin-left: 20px; margin-top: 10px;' class='btn' onclick='addNewSection(this)'>Add Section</button></div>"
      when "timeline"
        tempHTML += '<div class="event-entry champ-card">' +
            '<input maxlength="4"><br /><br />' +
            '<div><textarea></textarea><br />' + #we want to make a series of buttons for each event and for each point in each event
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
            '<br /><button class=\"btn\" id=\"build-timeline\" onclick=\"buildTimelineHTML()\">Build HTML</button>'
      when "vert-timeline"
        tempHTML += '<br/><button class="btn" onclick="addCoverPhoto(this)">Add Cover Photo</button><br/>' +
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
            '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button></div>'
      else break
    #once the empty templates are defined then they will be injected directly onto the screen
    document.getElementById("input-area").innerHTML = tempHTML
    return

#Pre: event html from a timeline page
#Post: returns an editable form filled with entries from the html given
#Purpose: this function is meant to parse the data from an event of a timeline
#page and translate it into raw data which it will insert into modifiable textareas
#then return this in raw html to the calling function
buildEvent = (event) ->
  html = "<div class='event-entry champ-card'>"
  year = event.getElementByTagName('h2')[0].innerHTML
  #as we want years in this form we will limit it to 4 characters
  html += '<input maxlength="4" value="' + year + '"><br /><br />'
  #check to see if there are any images in this event
  if event.getElementsByTagName('img').length
    html += '<div><h3 style="float: left; margin-bottom: 0;">Image Address: </h3><input style="margin-bottom: 0" class="timeline-image"' +
        ' value="' + event.getElementsByTagName('img')[0].getAttribute('src') + '"><br />' +
        '<button style="clear: left; float: left; margin-top: 0" class="btn" onclick="deleteEvent(this)">Remove Image</button><br /><br /><br /></div>'
  points = event.getElementsByTagName('p')
  for point in points
    html += '<div><textarea>#{point.innerHTML}</textarea>' +
      '<br /><button class="btn" onclick="newDetail(this)">Add</button>' +
      '<button class="btn" onclick="removeDetail(this)" style="margin-left: 5px;">Remove</button>' +
      '<button class="btn" onclick="moveUp(this)" style="margin-left: 5px;">Up</button>' +
      '<button class="btn" onclick="moveDown(this)" style="margin-left: 5px;">Down</button>' +
      '<br /><br /></div>'
  html += '<button class="btn" onclick="addEvent(this)">Add Event</button>' +
      '<button class="btn" onclick="deleteEvent(this)" style="margin-left: 5px;">Remove Event</button>' +
      '<button class="btn" onclick="moveUp(this)" style="margin-left: 5px;">Up</button>' +
      '<button class="btn" onclick="moveDown(this)" style="margin-left: 5px;">Down</button>' +
      '<button class="btn" onclick="addImage(this)" style="margin-left: 5px;">Add Image</button>' +
      '</div>'
  html
  
#Pre: takes in the button that calls this function
#Post: moves the parent element of the button above the previous element
#as long as they are the same type
#Purpose: this function is meant to help reorganize elements of different templates
moveUp = (button) ->
  prevElement = $(button.parentElement).prev()
  #if the element previous to the one selected is of the same type then we will move our element before it
  if $(button.parentElement).prop("tagName") is $(prevElement).prop("tagName")
    $(button.parentElement).detach().insertBefore(prevElement)
  return

#Pre: takes in the button that calls this function
#Post: moves the parent element of the button above the previous element
#as long as they have the class section video
#Purpose: the reason this function is used as an alternative to the moveUp function is
#so we don't swap a section with an event photo, as this would not actually change
#the position of the image in the event and confusion to the user should be avoided
moveSectionUp = (button) ->
  prevElement = $(button.parentElement).prev()
  if $(prevElement).hasClass('section-video')
    $(button.parentElement).detach().insertBefore(prevElement)
  return

#Pre: takes in the button that calls this function
#Post: moves the parent element of the button below the next element
#as long as they are the same type
#Purpose: this function is meant to help reorganize elements of different templates
moveDown = (button) ->
  nextElement = $(button.parentElement).next()
  if $(button.parentElement).prop("tagName") is $(nextElement).prop("tagName")
    $(button.parentElement).detach().insertAfter(nextElement)
  return
    
#Pre: takes in the button that calls this function
#Post: creates a blank template for a timeline page event and inserts it after this element
#Purpose: this function is meant to create a template for the timeline page so that more
#events can be added to the timeline
addEvent = (button) ->
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
      '</div>').insertAfter(button.parentElement)
  return
      
#Pre: takes in the button that calls this function
#Post: adds an input box for an image to be added to an event
#Purpose: this function is meant to add an input box that is for an address of an image
#that can be added to an event
addImage = (button) ->
  #each image input is headed by an h3 tag and if one doesn't exist in the same
  #div as the button then we will go ahead and add the image input
  if not button.parentElement.getElementsByTagName('h3').length
    $('<div><h3 style="float: left; margin-bottom: 0;">Image Address: </h3><input style="margin-bottom: 0" class="timeline-image"><br />' +
        '<button style="clear: left; float: left; margin-top: 0" class="btn" onclick="deleteEvent(this)">Remove Image</button><br /><br /><br /></div>').insertAfter($(button.parentElement.getElementsByTagName('input')[0]).next().next())
  return
        
#Pre: takes in the button that calls the function 
#Post: deletes the parent element of the button
#Purpose: to remove elements from the page
deleteEvent = (button) ->
  $(button.parentElement).remove()
  return
 
#Pre: takes in the button that calls the function
#Post: creates a new detail below the parent element of the button
#Purpose: this function is meant to create more details for the timeline page
newDetail = (button) ->
  $('<div><textarea></textarea><br />' +
      '<button class="btn" onclick="newDetail(this)">Add</button>' +
      '<button class="btn" onclick="removeDetail(this)" style="margin-left: 5px;">Remove</button>' +
      '<button class="btn" onclick="moveUp(this)" style="margin-left: 5px;">Up</button>' +
      '<button class="btn" onclick="moveDown(this)" style="margin-left: 5px;">Down</button>' +
      '<br /><br /></div>').insertAfter(button.parentElement)
  return

#Pre: takes in teh button that calls the function
#Post: if there is more than one text area in buttons parent element's parent element
#The button's parent element is removed
#Purpose: this is meant to be a function for removing details in a timeline event
removeDetail = (button) ->
  if button.parentElement.parentElement.getElementsByTagName('textarea').length >= 2
    $(button.parentElement).remove()
    return
    
#Pre: this function is called when someone clicks the build html button at the bottom of a timeline page
#Post: parses the data on the screen and outputs it in html format in the text box below
#Purpose: this function is meant to take the newly manipulated timeline and turn it into a format of
#HTML compatible with ACE-Timeline standards
buildTimelineHTML = ->
  timelineHTML = document.getElementById("timeline-html")
  events = document.getElementsByClassName('event-entry')
  tempHTML = "<ol>"
  for i in [0...events.length]
    currentEvent = events[i].getElementsByTagName('input')[0].value
    if not i
      tempHTML += '<li><a href=\"#0\" data-date=\"01/01/' + currentEvent + '\" class=\"selected\">' + currentEvent + '</a></li>'
    else
      tempHTML += '<li><a href=\"#0\" data-date=\"01/01/' + currentEvent + '\">' + currentEvent + '</a></li>'
  tempHTML += '</ol><span class=\"filling-line\" aria-hidden=\"true\"></span>'
  timelineHTML.getElementsByClassName('events')[0].innerHTML = tempHTML
  tempHTML = ""
  for i in [0...events.length]
    currentEvent = events[i].getElementsByTagName('input')[0].value
    if not i
      tempHTML += '<li class=\"selected\" data-date=\"01/01/' + currentEvent + '\">'
    else
      tempHTML += '<li data-date=\"01/01/' + currentEvent + '\">'
    tempHTML += '<h2>' + currentEvent + '</h2>'
    if events[i].getElementsByTagName('h3').length
      tempHTML += '<img src="' + events[i].getElementsByTagName('input')[1].value + '" style="width: 100%; height: auto;" /><br /><br />'
    tempHTML += '<p>' + point.value + '</p><br />' for point in events[i].getElementsByTagName('textarea')
    tempHTML += '</li>'
  timelineHTML.getElementsByClassName('events-content')[0].getElementsByTagName('ol')[0].innerHTML = tempHTML
  $("<br /><br /><textarea id=\"output-html\"></textarea>").insertAfter('#build-timeline')
  document.getElementById("output-html").value = timelineHTML.innerHTML
  return

#Pre: this function is called when someone clicks the build html button at the bottom of a video page
#Post: parses the data on the screen and outputs it in html format in the text box below
#Purpose: this function is meant to take the newly manipulated video and turn it into a format of
#HTML compatible with ACE-Video standards
buildVideoHTML = ->
  videoHTML = document.getElementById('video-page-html')
  feats = videoHTML.getElementsByClassName('video-feature')[0].getElementsByClassName('feat-objects')
  featsConContent = document.getElementsByClassName('feature-video')[0].getElementsByClassName('video-entry')
  for i in [0...4]
    feats[i].innerHTML = '<p class="video-url">' + featsConContent[i].getElementsByClassName('video-url')[0].value + '</p>' +
        '<p class="thumbnail-url">' + featsConContent[i].getElementsByClassName('video-thumb-url')[0].value + '</p>' +
        '<p class="video-description">' + featsConContent[i].getElementsByClassName('video-description')[0].value + '</p>'
  htmlOutput = videoHTML.innerHTML
  sections = document.getElementsByClassName('section-video')
  for i in [0...sections.length]
    htmlOutput += '<div class="video-section champ-card">' +
        '<div class="section-panel-left">' +
        '<h2>' + sections[i].getElementsByClassName('section-title')[0].value + '</h2><br />' +
        '<div class="video-section-main video"></div>' +
        '</div>' +
        '<div class="section-panel-right"></div>'
    entries = sections[i].getElementsByClassName('video-entry')
    for j in [0...4]
      htmlOutput += '<div class="video-section-object">' +
          '<p class="video-url-section">' + entries[j].getElementsByClassName('video-url')[0].value + '</p>' +
          '<p class="thumbnail-url-section">' + entries[j].getElementsByClassName('video-thumb-url')[0].value + '</p>' +
          '<p class="video-description-section">' + entries[j].getElementsByClassName('video-description')[0].value + '</p>' +
          '</div>'
    htmlOutput += '</div><br /><br />'
  $("<br /><br /><textarea id=\"output-html\"></textarea>").insertAfter('#build-video')
  document.getElementById("output-html").value = htmlOutput