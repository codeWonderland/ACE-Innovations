# This is a function that should be used for every large project to emulate the ls function in terminal
@ls = (location = document) ->
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
  if pageType.value isnt "" and html.value isnt ""
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
      when "contact-book"
        tempHTML += buildContact(contact) for contact in document.getElementById('contact-list').getElementsByClassName('contact')
        tempHTML += "<br /><button class='btn' id='build-contact-book' onclick='buildContactBookHTML()'>Build HTML</button>"
      else break
    #after the html from each section is translated appropriately, this will be injected directly into the page
    document.getElementById("input-area").innerHTML = tempHTML
    return
#if the page type is not selected, therefore the value is null
  else if pageType.value is ""
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
          if not (i % 2)
            tempHTML += "<div style='float: left; margin: 15px; margin-left: 100px;' class='video-entry champ-card'>"
          else
            tempHTML += "<div style='float: left; margin: 15px;' class='video-entry champ-card'>"
          #if this is the first element then it will be known as the main video
          if not i
            tempHTML += "<h3>Feature Video Main Video</h3>"
#if this is not the first video then it will be labeled by it's order in the list
          else
            tempHTML += "<h3>Feature Video Preview #{i}</h3>"
          tempHTML += "<p style='float: left'>URL:</p><input style='float: left' class='video-url'  /><br /><br />" +
              "<p style='float: left; padding-bottom: 0;'>Thumbnail URL:</p><input style='float: left' class='video-thumb-url'  />" +
              "<br /><p style='float:left; font-size: 10px; margin-top:0;'>Note: Make sure thumbnail is 16:9</p><br /><br />" +
              "<p style='float: left'>Description:</p><input style='float: left' class='video-description' maxlength='30'  /></div>"
          #after every other element there will be break points to create a second row of entry forms
          if i % 2
            tempHTML += "<br/><br/>"
        tempHTML += "<button style='float: left; margin-left: 20px; margin-top: 10px;' class='btn' onclick='addNewSection(this)'>Add Section</button></div>" +
          '<br /><button class="btn" id="build-video" onclick="buildVideoHTML()">Build HTML</button>'
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
            '<br /><button class="btn" id="build-timeline" onclick="buildTimelineHTML()">Build HTML</button>'
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
            '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button></div>' +
            '<br /><button class="btn" id="build-timeline" onclick="buildVertTimelineHTML()">Build HTML</button>'
      when "contact-book"
        tempHTML +=
          '<div class="container champ-card" style="clear: both; width: 100%;">\n' +
          '  <h2 style="float: left;">\n' +
          '  Contact Name:\n' +
          '  </h2>\n' +
          '  <input type="text" style="float: left; margin-top: -2px; width: 45%; margin-left: 7px; box-sizing: border-box; border: 2px solid #ccc; border-radius: 4px; font-size: 16px; background-color: white;padding: 7px;" maxlength="100">\n' +
          '  <div class="detail champ-card" style="clear: both; position: relative">\n' +
          '    <div class="heading-container" style="width: 50%; float: left;">\n' +
          '      <h2 style="margin-top: 0;">\n' +
          '      Detail\n' +
          '      </h2>\n' +
          '      <h3 style="float: left; margin-top: 0;">\n' +
          '      Heading:\n' +
          '      </h3>\n' +
          '      <input type="text" class="heading" maxlength="18" style="float: left; margin-top: -2px; margin-left: 5px; width: 60%">\n' +
          '    </div>\n' +
          '    <div class="detail-options" style="padding: 10px;">\n' +
          '      <input style="float: left" type="checkbox" onclick="noContactDetailHeading(this)"><p style="margin-top: -4px;">No Heading</p>\n' +
          '      <input style="float: left" type="checkbox" onclick="contactDetailIsLink(this)"><p style="margin-top: -4px;">Detail is Link</p>\n' +
          '      <input style="float: left" type="checkbox" onclick="contactDetailIsButton(this)"><p style="margin-top: -4px;">Detail is Button</p>\n' +
          '    </div>\n' +
          '    <h3 class="line-header">Lines:</h3>\n' +
          '    <div class="line-container">\n' +
          '      <input type="text" maxlength="24" style="width: 45%; border: 1px solid lightgrey; box-sizing: border-box; border: 2px solid #ccc; border-radius: 4px; font-size: 16px; background-color: white;padding: 7px; margin-bottom: 5px;" class="line">\n' +
          '      <a class="btn" onclick="addContactDetailLine(this)">+</a>\n' +
          '      <a class="btn" onclick="deleteContactDetailLine(this)">−</a>\n' +
          '      <a class="btn" onclick="moveUp(this)">↑</a>\n' +
          '      <a class="btn" onclick="moveDown(this)">↓</a>\n' +
          '    </div> \n' +
          '    <p class="disclaimer">* Lines have a 24 character limit for styling purposes</p>' +
          '    <a class="btn" onclick="addContactDetail(this)">Add Detail</a>\n' +
          '    <a class="btn" onclick="deleteContactDetail(this)">Delete</a>\n' +
          '    <a class="btn" onclick="moveUp(this)">Move Up</a>\n' +
          '    <a class="btn" onclick="moveDown(this)">Move Down</a>\n' +
          '  </div>\n' +
          '  <a class="btn" onclick="addContact(this)">Add Contact</a>\n' +
          '  <a class="btn" onclick="deleteContact(this)">Delete</a>\n' +
          '  <a class="btn" onclick="moveUp(this)">Move Up</a>\n' +
          '  <a class="btn" onclick="moveDown(this)">Move Down</a>\n' +
          '</div>' +
          '<br /><button class="btn" id="build-contact-book" onclick="buildContactBookHTML()">Build HTML</button>'
      else break
    #once the empty templates are defined then they will be injected directly onto the screen
    document.getElementById("input-area").innerHTML = tempHTML
    return

#Pre: event html from a timeline page
#Post: returns an editable form filled with entries from the html given
#Purpose: this function is meant to parse the data from an event of a timeline
#page and translate it into raw data which it will insert into modifiable textareas
#then return this in raw html to the calling function
@buildEvent = (event) ->
  html = "<div class='event-entry champ-card'>"
  year = event.getElementsByTagName('h2')[0].innerHTML
  #as we want years in this form we will limit it to 4 characters
  html += '<input maxlength="4" value="' + year + '"><br /><br />'
  #check to see if there are any images in this event
  if event.getElementsByTagName('img').length
    html += '<div><h3 style="float: left; margin-bottom: 0;">Image Address: </h3><input style="margin-bottom: 0" class="timeline-image"' +
        ' value="' + event.getElementsByTagName('img')[0].getAttribute('src') + '"><br />' +
        '<button style="clear: left; float: left; margin-top: 0" class="btn" onclick="deleteEvent(this)">Remove Image</button><br /><br /><br /></div>'
  points = event.getElementsByTagName('p')
  for point in points
    html += '<div><textarea>' + point.innerHTML + '</textarea>' +
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
@moveUp = (button) ->
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
@moveSectionUp = (button) ->
  prevElement = $(button.parentElement).prev()
  if $(prevElement).hasClass('section-video')
    $(button.parentElement).detach().insertBefore(prevElement)
  return

#Pre: takes in the button that calls this function
#Post: moves the parent element of the button below the next element
#as long as they are the same type
#Purpose: this function is meant to help reorganize elements of different templates
@moveDown = (button) ->
  nextElement = $(button.parentElement).next()
  if $(button.parentElement).prop("tagName") is $(nextElement).prop("tagName")
    $(button.parentElement).detach().insertAfter(nextElement)
  return

#Pre: takes in the button that calls this function
#Post: creates a blank template for a timeline page event and inserts it after this element
#Purpose: this function is meant to create a template for the timeline page so that more
#events can be added to the timeline
@addEvent = (button) ->
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
@addImage = (button) ->
#each image input is headed by an h3 tag and if one doesn't exist in the same
#div as the button then we will go ahead and add the image input
  if not button.parentElement.getElementsByTagName('h3').length
    $('<div><h3 style="float: left; margin-bottom: 0;">Image Address: </h3><input style="margin-bottom: 0" class="timeline-image"><br />' +
        '<button style="clear: left; float: left; margin-top: 0" class="btn" onclick="deleteEvent(this)">Remove Image</button><br /><br /><br /></div>').insertAfter($(button.parentElement.getElementsByTagName('input')[0]).next().next())
  return

#Pre: takes in the button that calls the function
#Post: deletes the parent element of the button
#Purpose: to remove elements from the page
@deleteEvent = (button) ->
  $(button.parentElement).remove()
  return

#Pre: takes in the button that calls the function
#Post: creates a new detail below the parent element of the button
#Purpose: this function is meant to create more details for the timeline page
@newDetail = (button) ->
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
@removeDetail = (button) ->
  if button.parentElement.parentElement.getElementsByTagName('textarea').length >= 2
    $(button.parentElement).remove()
    return

#Pre: this function is called when someone clicks the build html button at the bottom of a timeline page
#Post: parses the data on the screen and outputs it in html format in the text box below
#Purpose: this function is meant to take the newly manipulated timeline and turn it into a format of
#HTML compatible with ACE-Timeline standards
@buildTimelineHTML = ->
  timelineHTML = document.getElementById("timeline-html")
  events = document.getElementsByClassName('event-entry')
  tempHTML = "<ol>"
  #we need to get all of the events from the page and make the links on the timeline display
  for i in [0...events.length]
    currentEvent = events[i].getElementsByTagName('input')[0].value
    if not i
      tempHTML += '<li><a href="#0" data-date="01/01/' + currentEvent + '" class="selected">' + currentEvent + '</a></li>'
    else
      tempHTML += '<li><a href="#0" data-date="01/01/' + currentEvent + '">' + currentEvent + '</a></li>'
  tempHTML += '</ol><span class="filling-line" aria-hidden="true"></span>'
  timelineHTML.getElementsByClassName('events')[0].innerHTML = tempHTML
  tempHTML = ""
  #here we take the events and make the actual content for each timeline event
  for i in [0...events.length]
    currentEvent = events[i].getElementsByTagName('input')[0].value
    if not i
      tempHTML += '<li class="selected" data-date="01/01/' + currentEvent + '">'
    else
      tempHTML += '<li data-date="01/01/' + currentEvent + '">'
    tempHTML += '<h2>' + currentEvent + '</h2>'
    if events[i].getElementsByTagName('h3').length
      tempHTML += '<img src="' + events[i].getElementsByTagName('input')[1].value + '" style="width: 100%; height: auto;" /><br /><br />'
    tempHTML += '<p>' + point.value + '</p><br />' for point in events[i].getElementsByTagName('textarea')
    tempHTML += '</li>'
  timelineHTML.getElementsByClassName('events-content')[0].getElementsByTagName('ol')[0].innerHTML = tempHTML
  #here we add the textarea for the html then add the html
  $('<br /><br /><textarea id="output-html"></textarea>').insertAfter('#build-timeline')
  document.getElementById("output-html").value = timelineHTML.innerHTML
  return

# Todo pre, post, purpose
@buildContactBookHTML = ->
  contactHTML = document.getElementById('contact-book-html')
  contacts = document.getElementsByClassName('container')
  tempHTML = ''
  for contact in contacts
    tempHTML += '<div class="contact">
                 <p class="name">' + contact.getElementsByTagName('input')[0].value + '</p>'
    
    for detail in contact.getElementsByClassName('detail')
      tempHTML += '<div class="detail">'
      
      if not detail.getElementsByClassName('detail-options')[0].getElementsByTagName('input')[0].checked
        tempHTML += '<p class="heading">' + detail.getElementsByClassName('heading-container')[0].getElementsByClassName('heading')[0].value + '</p>'
        
      if detail.getElementsByClassName('detail-options')[0].getElementsByTagName('input')[1].checked
        for link in detail.getElementsByClassName('link-container')
          tempHTML += '<a class="link" href="' + link.getElementsByTagName('input')[2].value + '" title="' + link.getElementsByTagName('input')[1].value + '">' + link.getElementsByTagName('input')[0].value + '</a>'
      
      else if detail.getElementsByClassName('detail-options')[0].getElementsByTagName('input')[2].checked
        btn = detail.getElementsByClassName('btn-container')[0]
        tempHTML += '<a class="btn" href="' + btn.getElementsByTagName('input')[2].value + '" title="' + btn.getElementsByTagName('input')[1].value + '">' + btn.getElementsByTagName('input')[0].value + '</a>'

      else
        for line in detail.getElementsByClassName('line-container')
          tempHTML += '<p class="line">' + line.getElementsByTagName('input')[0].value + '</p>'
      
      tempHTML += '</div>'
    
    tempHTML += '</div>'
  
  contactHTML.getElementsByTagName('div')[4].innerHTML = tempHTML
  $('<br /><br /><textarea id="output-html"></textarea>').insertAfter('#build-contact-book')
  document.getElementById("output-html").value = contactHTML.innerHTML
  
#Pre: this function is called when someone clicks the build html button at the bottom of a video page
#Post: parses the data on the screen and outputs it in html format in the text box below
#Purpose: this function is meant to take the newly manipulated video and turn it into a format of
#HTML compatible with ACE-Video standards
@buildVideoHTML = ->
  videoHTML = document.getElementById('video-page-html')
  feats = videoHTML.getElementsByClassName('video-feature')[0].getElementsByClassName('feat-objects')
  featsConContent = document.getElementsByClassName('feature-video')[0].getElementsByClassName('video-entry')
  #get the video info for the feature video
  for i in [0...4]
    feats[i].innerHTML = '<p class="video-url">' + featsConContent[i].getElementsByClassName('video-url')[0].value + '</p>' +
        '<p class="thumbnail-url">' + featsConContent[i].getElementsByClassName('video-thumb-url')[0].value + '</p>' +
        '<p class="video-description">' + featsConContent[i].getElementsByClassName('video-description')[0].value + '</p>'
  htmlOutput = videoHTML.innerHTML
  sections = document.getElementsByClassName('section-video')
  #check for sections then build html for each one
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
  #add textarea below the button and put the html inside of it
  $('<br /><br /><textarea id="output-html"></textarea>').insertAfter('#build-video')
  document.getElementById("output-html").value = htmlOutput
  return

#Pre: takes in a contact from the html of a contact book
#Post: modifies the html into something compliant with the page builder
#Purpose: this takes raw html from a ACE-Contact-Book page and makes it modifiable
@buildContact = (contact) ->
  tempHTML = '<div class="container champ-card" style="clear: both; width: 100%">
                  <h2 style="float: left">Contact Name:</h2>
                  <input type="text" style="float: left; margin-top: -2px; width: 45%; margin-left: 7px; box-sizing: border-box; border: 2px solid #ccc; border-radius: 4px; font-size: 16px; background-color: white;padding: 7px;" maxlength="100" value="' + contact.getElementsByClassName('name')[0].innerHTML + '">'
  tempHTML += buildContactDetail(detail) for detail in contact.getElementsByClassName('detail')
  tempHTML += '<a class="btn" onclick="addContact(this)">Add Contact</a>
               <a class="btn" onclick="deleteContact(this)">Delete</a>
               <a class="btn" onclick="moveUp(this)">Move Up</a>
               <a class="btn" onclick="moveDown(this)">Move Down</a>
               </div>'
  return tempHTML

@buildContactDetail = (detail) ->
  tempHTML = '<div class="detail champ-card" style="clear: both; position: relative">' +
             '  <div class="heading-container" style="width: 50%; float: left;">' +
             '     <h2 style="margin-top: 0;">' +
             '        Detail' +
             '     </h2>' +
             '     <h3 style="float: left; margin-top: 0;">' +
             '        Heading:' +
             '     </h3>'
  
  if detail.getElementsByClassName('heading').length
    tempHTML += '<input type="text" class="heading" maxlength="18" style="float: left; margin-top: -2px; margin-left: 5px; width: 60%" value="' + detail.getElementsByClassName('heading')[0].innerHTML + '">'
  else
    tempHTML += '<input type="text" class="heading" maxlength="18" style="float: left; margin-top: -2px; margin-left: 5px; width: 60%" disabled>'
    
  tempHTML += '</div>' +
              '<div class="detail-options" style="padding: 10px;">'
  
  if detail.getElementsByClassName('heading').length
    tempHTML += '<input style="float: left" type="checkbox" onclick="noContactDetailHeading(this)"><p style="margin-top: -4px;">No Heading</p>'
  else
    tempHTML += '<input style="float: left" type="checkbox" onclick="noContactDetailHeading(this)" checked><p style="margin-top: -4px;">No Heading</p>'
    
  if detail.getElementsByClassName('link').length
    tempHTML += '<input style="float: left" type="checkbox" onclick="contactDetailIsLink(this)" checked><p style="margin-top: -4px;">Detail is Link</p>
                 <input style="float: left" type="checkbox" onclick="contactDetailIsButton(this)" disabled><p style="margin-top: -4px;">Detail is Button</p>'
  else if detail.getElementsByClassName('btn').length
    tempHTML += '<input style="float: left" type="checkbox" onclick="contactDetailIsLink(this)" disabled><p style="margin-top: -4px;">Detail is Link</p>
                 <input style="float: left" type="checkbox" onclick="contactDetailIsButton(this)" checked><p style="margin-top: -4px;">Detail is Button</p>'
  else
    tempHTML += '<input style="float: left" type="checkbox" onclick="contactDetailIsLink(this)"><p style="margin-top: -4px;">Detail is Link</p>
                 <input style="float: left" type="checkbox" onclick="contactDetailIsButton(this)"><p style="margin-top: -4px;">Detail is Button</p>'
  
  tempHTML += '</div>'
  
  if detail.getElementsByClassName('line').length
    tempHTML += '<h3 class="line-header">Lines:</h3>'
    for line in detail.getElementsByClassName('line')
      tempHTML += '<div class="line-container">' +
                  '  <input type="text" maxlength="24" style="width: 45%; border: 1px solid lightgrey; box-sizing: border-box; border: 2px solid #ccc; border-radius: 4px; font-size: 16px; background-color: white;padding: 7px; margin-bottom: 5px;" class="line" value="' + line.innerHTML + '">' +
                  '  <a class="btn" onclick="addContactDetailLine(this)">+</a>' +
                  '  <a class="btn" onclick="deleteContactDetailLine(this)">−</a>' +
                  '  <a class="btn" onclick="moveUp(this)">↑</a>' +
                  '  <a class="btn" onclick="moveDown(this)">↓</a>' +
                  '</div>'
      
  else if detail.getElementsByClassName('link').length
    tempHTML += '<h3 class="line-header">Links:</h3>'
    for link in detail.getElementsByClassName('link')
      tempHTML += '<div class="link-container champ-card" style="width: 100%; position: relative;">
                     <div class="link-details" style="float: left; width: 90%">
                       <h3 style="margin-bottom: 0; margin-top: 0;">Link Name:</h3>
                       <input type="text" maxlength="23" value="' + link.innerHTML + '">
                       <h3 style="margin-bottom: 0;">Link Description:</h3>
                       <input type="text" value="' + link.title + '">
                       <h3 style="margin-bottom: 0;">Location (URL):</h3>
                       <input type="text" value="' + link.href + '">
                     </div>
                     <div class="link-controls" style="width: 10%; padding: 3%; float: right;">
                       <a class="btn" style="margin: 17%;" onclick="addContactDetailLink(this)">+</a>
                       <a class="btn" style="margin: 17%;" onclick="deleteContactDetailLink(this)">−</a>
                       <a class="btn" style="margin: 17%;" onclick="moveContactLinkUp(this)">↑</a>
                       <a class="btn" style="margin: 17%;" onclick="moveContactLinkDown(this)">↓</a>
                     </div>
                     <p>* For email addresses preface location with mailto: as such mailto:example@champlain.edu</p>
                  </div>'

  else if detail.getElementsByClassName('btn').length
    tempHTML += '<div class="btn-container" style="width: 100%; position: relative;">
                  <h3 style="margin-bottom: 0; margin-top: 0;">Button Name:</h3>
                  <input type="text" maxlength="18" value="' + detail.getElementsByClassName('btn')[0].innerHTML + '">
                  <h3 style="margin-bottom: 0;">Button Description:</h3>
                  <input type="text" value="' + detail.getElementsByClassName('btn')[0].title + '">
                  <h3 style="margin-bottom: 0;">Location (URL):</h3>
                  <input type="text" value="' + detail.getElementsByClassName('btn')[0].href + '">
                  <p>* Only one button per detail</p>
                </div>'
      
  tempHTML += '  <p class="disclaimer">* Lines have a 24 character limit for styling purposes</p>' +
              '  <a class="btn" onclick="addContactDetail(this)">Add Detail</a>' +
              '  <a class="btn" onclick="deleteContactDetail(this)">Delete</a>' +
              '  <a class="btn" onclick="moveUp(this)">Move Up</a>' +
              '  <a class="btn" onclick="moveDown(this)">Move Down</a>' +
              '</div>'
  return tempHTML
  
#Pre: takes in a feature from html of a video page
#Post: modifies the html into something compliant with the page builder
#Purpose: this takes raw html from a ACE-Video page and makes it modifiable
@buildFeature = (feature) ->
  featurehtml = "<div style='height: 610px;' class='feature-video champ-card'><h2>Feature Video</h2>"
  objects = feature.getElementsByClassName('feat-objects')
  for i in [0...4]
    if not (i % 2)
      featurehtml += "<div style='float: left; margin: 15px; margin-left: 100px' class='video-entry champ-card'>"
    else
      featurehtml += "<div style='float: left; margin: 15px;' class='video-entry champ-card'>"
    if not i
      featurehtml += "<h3>Feature Video Main Video</h3>"
    else
      featurehtml += "<h3>Feature Video Preview " + i + "</h3>"
    vidurl = objects[i].getElementsByClassName('video-url')[0].innerHTML
    thumb = objects[i].getElementsByClassName('thumbnail-url')[0].innerHTML
    descript = objects[i].getElementsByClassName('video-description')[0].innerHTML
    featurehtml += "<p style='float: left'>URL:</p><input style='float: left' class='video-url' value='" + vidurl + "' /><br /><br />"
    featurehtml += "<p style='float: left; padding-bottom: 0;'>Thumbnail URL:</p><input style='float: left' class='video-thumb-url' value='" + thumb + "' /><br /><p style='float:left; font-size: 10px; margin-top:0;'>Note: Make sure thumbnail is 16:9</p><br /><br />"
    featurehtml += "<p style='float: left'>Description:</p><input style='float: left' class='video-description' maxlength='30' value='" + descript + "' />"
    featurehtml += "</div>"
    if i % 2
      featurehtml+="<br /><br />"
  featurehtml += "<button style='float: left; margin-left: 20px; margin-top: 10px;' class='btn' onclick='addNewSection(this)'>Add Section</button></div>"
  return featurehtml

#Pre: takes in a section from html of a video page
#Post: modifies the html into something complient with the page builder
#Purpose: this takes raw html from a ACE-Video page and makes it modifiable
@buildSection = (section) ->
  sectionhtml = "<div style='height: 650px;' class='section-video champ-card'><h2>Video Section</h2>"
  sectionhtml += "<p style='float: left'>Section Title</p><input style='float: left' class='section-title' value='" + section.getElementsByTagName('h2')[0].innerHTML + "' /><br /><br />"
  objects = section.getElementsByClassName('video-section-object')
  for i in [0...4]
    if not (i % 2)
      sectionhtml += "<div style='float: left; margin: 15px; margin-left: 100px' class='video-entry champ-card'>"
    else
      sectionhtml += "<div style='float: left; margin: 15px;' class='video-entry champ-card'>"
    if not i
      sectionhtml += "<h3>Section Video Main Video</h3>"
    else
      sectionhtml += "<h3>Section Video Preview " + i + "</h3>"
    vidurl = objects[i].getElementsByClassName('video-url-section')[0].innerHTML
    thumb = objects[i].getElementsByClassName('thumbnail-url-section')[0].innerHTML
    descript = objects[i].getElementsByClassName('video-description-section')[0].innerHTML
    sectionhtml += "<p style='float: left'>URL:</p><input style='float: left' class='video-url' value='" + vidurl + "' /><br /><br />"
    sectionhtml += "<p style='float: left; padding-bottom: 0;'>Thumbnail URL:</p><input style='float: left' class='video-thumb-url' value='" + thumb + "' /><br /><p style='float:left; font-size: 10px; margin-top:0;'>Note: Make sure thumbnail is 16:9</p><br /><br />"
    sectionhtml += "<p style='float: left'>Description:</p><input style='float: left' class='video-description' maxlength='30' value='" + descript + "' />"
    sectionhtml += "</div>"
    if i % 2
      sectionhtml+="<br /><br />"
  sectionhtml += "<button style='float: left; margin-left: 20px; margin-top: 10px;' class='btn' onclick='addNewSection(this)'>Add Section</button>"
  sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='deleteEvent(this)'>Remove Section</button>"
  sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='moveSectionUp(this)'>Move Up</button>"
  sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='moveDown(this)'>Move Down</button></div>"
  return sectionhtml

#Pre: takes in the button that calls it
#Post: adds a new modifiable section for the video page
#Purpose: to create more sections for the ACE-Video page
@addNewSection = (button) ->
  sectionhtml = "<div style='height: 650px;' class='section-video champ-card'><h2>Video Section</h2>"
  sectionhtml += "<p style='float: left'>Section Title</p><input style='float: left' class='section-title' /><br /><br />"
  for i in [0...4]
    if not (i % 2)
      sectionhtml += "<div style='float: left; margin: 15px; margin-left: 100px' class='video-entry champ-card'>"
    else
      sectionhtml += "<div style='float: left; margin: 15px;' class='video-entry champ-card'>"
    if not i
      sectionhtml += "<h3>Section Video Main Video</h3>"
    else
      sectionhtml += "<h3>Section Video Preview " + i + "</h3>"
    sectionhtml += "<p style='float: left'>URL:</p><input style='float: left' class='video-url' /><br /><br />"
    sectionhtml += "<p style='float: left; padding-bottom: 0;'>Thumbnail URL:</p><input style='float: left' class='video-thumb-url' /><br /><p style='float:left; font-size: 10px; margin-top:0;'>Note: Make sure thumbnail is 16:9</p><br /><br />"
    sectionhtml += "<p style='float: left'>Description:</p><input style='float: left' class='video-description' maxlength='30' />"
    sectionhtml += "</div>"
    if i % 2
      sectionhtml+="<br /><br />"
  sectionhtml += "<button style='float: left; margin-left: 20px; margin-top: 10px;' class='btn' onclick='addNewSection(this)'>Add Section</button>"
  sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='deleteEvent(this)'>Remove Section</button>"
  sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='moveSectionUp(this)'>Move Up</button>"
  sectionhtml += "<button style='float: left; margin-top: 10px; margin-left: 5px;' class='btn' onclick='moveDown(this)'>Move Down</button></div>"
  $(sectionhtml).insertAfter($(button.parentElement))
  return

#Pre: takes in a container holding html for a vertical timeline page
#Post: returns the html for a modifiable timeline
#Purpose: this function is meant to build a modifiable interface for ACE-Vert-Timelines
@buildVertTimeline = (container) ->
  tempHTML = ""
  if document.getElementsByClassName('vert-timeline-image').length
    tempHTML += '<br/><div><h3 style="float: left; margin-bottom: 0;">Image Address: </h3><input style="margin-bottom: 0; margin-top: 15px;" ' +
        'value="' + document.getElementsByClassName('vert-timeline-image')[0].getAttribute('src') + '" class="timeline-image"><br />' +
        '<button style="clear: left; float: left; margin-top: 0" class="btn" onclick="removeCoverPhoto(this)">Remove Image</button><br /><br /></div>'
  else
    tempHTML += '<br/><button class="btn" onclick="addCoverPhoto(this)">Add Cover Photo</button><br/>'
  events = container.getElementsByClassName('timeline-item')
  for i in [0...events.length]
    tempHTML += '<div class="event-element champ-card"><input class="event-element-header" type="text" value="' + events[i].getAttribute('data-year') + '"><br /><br />'
    points = events[i].getElementsByTagName('li')
    for j in [0...points.length]
      tempHTML += '<div><textarea class="event-element-point">' + points[j].innerHTML + '</textarea>' +
          '<br/><button class="btn" style="margin-left: 5px" onclick="addElement(this)">Add Detail</button>' +
          '<button class="btn" style="margin-left: 5px" onclick="removeDetail(this)">Remove Detail</button>' +
          '<button class="btn" style="margin-left: 5px" onclick="moveUp(this)">Move Up</button>' +
          '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button>' +
          '<br/><br/></div>'
    tempHTML += '<button class="btn" style="margin-left: 5px" onclick="addTimelineElement(this)">Add Event</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="deleteEvent(this)">Remove Event</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="moveUp(this)">Move Up</button>' +
        '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button></div>'
  return tempHTML

#Pre: takes in the button that calls it
#Post: adds a new cover image for the vertical timeline page
#Purpose: to create a cover image for the ACE-Vert-Timeline Page
@addCoverPhoto = (button) ->
  if not button.parentElement.getElementsByTagName('h3').length
    $('<div><h3 style="float: left; margin-bottom: 0;">Image Address: </h3><input style="margin-bottom: 0; margin-top: 15px;" class="timeline-image"><br />' +
        '<button style="clear: left; float: left; margin-top: 0" class="btn" onclick="removeCoverPhoto(this)">Remove Image</button><br /><br /></div>').insertBefore(button)
    button.remove()
  return

#Pre: takes in the button that calls it
#Post: removes the cover image for the vertical timeline page
#Purpose: to remove a cover image for the ACE-Vert-Timeline Page
@removeCoverPhoto = (button) ->
  $('<button class="btn" onclick="addCoverPhoto(this)">Add Cover Photo</button>').insertBefore(button.parentElement)
  button.parentElement.remove()
  return

#Pre: takes in the button that calls it
#Post: adds new event to the timeline
#Purpose: to expand an ACE-Vert-Timeline
@addTimelineElement = (button) ->
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
      '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button></div>').insertAfter(button.parentElement)
  return

#Pre: takes in the button that calls it
#Post: adds new detail to a timeline event
#Purpose: to expand an ACE-Timeline
@addElement = (button) ->
  $('<div><textarea class="event-element-point"></textarea>' +
      '<br/><button class="btn" style="margin-left: 5px" onclick="addElement(this)">Add Detail</button>' +
      '<button class="btn" style="margin-left: 5px" onclick="removeDetail(this)">Remove Detail</button>' +
      '<button class="btn" style="margin-left: 5px" onclick="moveUp(this)">Move Up</button>' +
      '<button class="btn" style="margin-left: 5px" onclick="moveDown(this)">Move Down</button>' +
      '<br/><br/></div>').insertAfter(button.parentElement)
  return

#Pre: this function is called when someone clicks the build html button at the bottom of a vertical timeline page
#Post: parses the data on the screen and outputs it in html format in the text box below
#Purpose: this function is meant to take the newly manipulated video and turn it into a format of
#HTML compatible with ACE-Vert-Timeline standards
@buildVertTimelineHTML = ->
  tempHTML = ""
  if document.getElementsByClassName('timeline-image').length
    tempHTML += '<img style="width: 100%; height: auto;" class="vert-timeline-image" src="' + document.getElementsByClassName('timeline-image')[0].value + '" />'
  tempHTML += '<div class="container">'
  events = document.getElementsByClassName('event-element')
  for event in events
    tempHTML += '<div class="timeline-item" data-year="' + event.getElementsByClassName('event-element-header')[0].value + '">' +
        '<div class="time-card"><ul>'
    points = event.getElementsByClassName('event-element-point')
    tempHTML += '<li>' + point.value + '</li>' for point in points
    tempHTML += '</ul></div></div>'
  tempHTML += '</div>'
  $('<br /><br /><textarea id="output-html"></textarea>').insertAfter('#build-vert-timeline')
  document.getElementById("output-html").value = tempHTML
  return

#Pre: Contact Book Detail
#Post: Greys out Heading input in detail
#Purpose: This will make the heading feild null on a detail for a contact book
@noContactDetailHeading = (checkbox) ->
  checkbox.parentNode.parentNode.getElementsByClassName('heading-container')[0].getElementsByClassName('heading')[0].disabled = !checkbox.parentNode.parentNode.getElementsByClassName('heading-container')[0].getElementsByClassName('heading')[0].disabled
  return

#Pre: Contact Book Detail
#Post: Adds new line to detail in contact book
#Purpose: to add new line to detail in contact book
@addContactDetailLine = (button) ->
  $('<div class="line-container">
      <input type="text" maxlength="24" style="width: 45%; border: 1px solid lightgrey; box-sizing: border-box; border: 2px solid #ccc; border-radius: 4px; font-size: 16px; background-color: white;padding: 7px; margin-bottom: 5px;" class="line">
      <a class="btn" onclick="addContactDetailLine(this)">+</a>
      <a class="btn" onclick="deleteContactDetailLine(this)">−</a>
      <a class="btn" onclick="moveUp(this)">↑</a>
      <a class="btn" onclick="moveDown(this)">↓</a>
      </div>').insertAfter(button.parentNode)
  return

#Pre: Contact Book Detail
#Post: deletes line from detail in contact book
#Purpose: deletes line from detail in contact book
@deleteContactDetailLine = (button) ->
  if button.parentNode.parentNode.getElementsByClassName('line-container').length - 1
    $(button.parentNode).remove()
  return

#Pre: Contact Book Detail
#Post: Adds new detail in contact book
#Purpose: to add new detail in contact book
@addContactDetail = (button) ->
  $('<div class="detail champ-card" style="clear: both; position: relative">' +
    '  <div class="heading-container" style="width: 50%; float: left;">' +
    '     <h2 style="margin-top: 0;">' +
    '        Detail' +
    '     </h2>' +
    '     <h3 style="float: left; margin-top: 0;">' +
    '        Heading:' +
    '     </h3>' +
    '     <input type="text" class="heading" maxlength="18" style="float: left; margin-top: -2px; margin-left: 5px; width: 60%">' +
    '  </div>' +
    '  <div class="detail-options" style="padding: 10px;">' +
    '     <input style="float: left" type="checkbox" onclick="noContactDetailHeading(this)"><p style="margin-top: -4px;">No Heading</p>' +
    '     <input style="float: left" type="checkbox" onclick="contactDetailIsLink(this)"><p style="margin-top: -4px;">Detail is Link</p>' +
    '     <input style="float: left" type="checkbox" onclick="contactDetailIsButton(this)"><p style="margin-top: -4px;">Detail is Button</p>' +
    '  </div>' +
    '  <h3 class="line-header">Lines:</h3>' +
    '  <div class="line-container">' +
    '     <input type="text" maxlength="24" style="width: 45%; border: 1px solid lightgrey; box-sizing: border-box; border: 2px solid #ccc; border-radius: 4px; font-size: 16px; background-color: white;padding: 7px; margin-bottom: 5px;" class="line">' +
    '     <a class="btn" onclick="addContactDetailLine(this)">+</a>' +
    '     <a class="btn" onclick="deleteContactDetailLine(this)">−</a>' +
    '     <a class="btn" onclick="moveUp(this)">↑</a>' +
    '     <a class="btn" onclick="moveDown(this)">↓</a>' +
    '  </div>' +
    '  <p class="disclaimer">* Lines have a 24 character limit for styling purposes</p>' +
    '  <a class="btn" onclick="addContactDetail(this)">Add Detail</a>' +
    '  <a class="btn" onclick="deleteContactDetail(this)">Delete</a>' +
    '  <a class="btn" onclick="moveUp(this)">Move Up</a>' +
    '  <a class="btn" onclick="moveDown(this)">Move Down</a>' +
    '</div>').insertAfter(button.parentNode)
  return

#Pre: Contact Book Detail
#Post: deletes detail in contact book
#Purpose: deletes detail in contact book
@deleteContactDetail = (button) ->
  if button.parentNode.parentNode.getElementsByClassName('detail').length - 1
    $(button.parentNode).remove()
  return

#Pre: Contact Book Detail
#Post: Adds new contact in contact book
#Purpose: to add new contact in contact book
@addContact = (button) ->
  $('<div class="container champ-card" style="clear: both; width: 100%;">\n' +
    '  <h2 style="float: left;">\n' +
    '  Contact Name:\n' +
    '  </h2>\n' +
    '  <input type="text" style="float: left; margin-top: -2px; width: 45%; margin-left: 7px; box-sizing: border-box; border: 2px solid #ccc; border-radius: 4px; font-size: 16px; background-color: white;padding: 7px;" maxlength="100">\n' +
    '  <div class="detail champ-card" style="clear: both; position: relative">\n' +
    '    <div class="heading-container" style="width: 50%; float: left;">\n' +
    '      <h2 style="margin-top: 0;">\n' +
    '      Detail\n' +
    '      </h2>\n' +
    '      <h3 style="float: left; margin-top: 0;">\n' +
    '      Heading:\n' +
    '      </h3>\n' +
    '      <input type="text" class="heading" maxlength="18" style="float: left; margin-top: -2px; margin-left: 5px; width: 60%">\n' +
    '    </div>\n' +
    '    <div class="detail-options" style="padding: 10px;">\n' +
    '      <input style="float: left" type="checkbox" onclick="noContactDetailHeading(this)"><p style="margin-top: -4px;">No Heading</p>\n' +
    '      <input style="float: left" type="checkbox" onclick="contactDetailIsLink(this)"><p style="margin-top: -4px;">Detail is Link</p>\n' +
    '      <input style="float: left" type="checkbox" onclick="contactDetailIsButton(this)"><p style="margin-top: -4px;">Detail is Button</p>\n' +
    '    </div>\n' +
    '    <h3 class="line-header">Lines:</h3>\n' +
    '    <div class="line-container">\n' +
    '      <input type="text" maxlength="24" style="width: 45%; border: 1px solid lightgrey; box-sizing: border-box; border: 2px solid #ccc; border-radius: 4px; font-size: 16px; background-color: white;padding: 7px; margin-bottom: 5px;" class="line">\n' +
    '      <a class="btn" onclick="addContactDetailLine(this)">+</a>\n' +
    '      <a class="btn" onclick="deleteContactDetailLine(this)">−</a>\n' +
    '      <a class="btn" onclick="moveUp(this)">↑</a>\n' +
    '      <a class="btn" onclick="moveDown(this)">↓</a>\n' +
    '    </div> \n' +
    '    <p class="disclaimer">* Lines have a 24 character limit for styling purposes</p>' +
    '    <a class="btn" onclick="addContactDetail(this)">Add Detail</a>\n' +
    '    <a class="btn" onclick="deleteContactDetail(this)">Delete</a>\n' +
    '    <a class="btn" onclick="moveUp(this)">Move Up</a>\n' +
    '    <a class="btn" onclick="moveDown(this)">Move Down</a>\n' +
    '  </div>\n' +
    '  <a class="btn" onclick="addContact(this)">Add Contact</a>\n' +
    '  <a class="btn" onclick="deleteContact(this)">Delete</a>\n' +
    '  <a class="btn" onclick="moveUp(this)">Move Up</a>\n' +
    '  <a class="btn" onclick="moveDown(this)">Move Down</a>\n' +
    '</div>').insertAfter(button.parentNode)
  return

#Pre: Contact Book Detail
#Post: deletes contact in contact book
#Purpose: deletes contact in contact book
@deleteContact = (button) ->
  if button.parentNode.parentNode.getElementsByClassName('container').length - 1
    $(button.parentNode).remove()
  return
  
#Pre: Contact Book Detail
#Post: Replaces Lines with Links or vice Versa
#Post: To allow for links in the contact book
@contactDetailIsLink = (button) ->
  if button.checked
    # If the button is checked we want to remove any lines that may exist and disable the 'Detail is Button' button
    $(button.parentNode.parentNode.getElementsByClassName('line-container')).remove()
    button.parentNode.getElementsByTagName('input')[2].disabled = true
    
    button.parentNode.parentNode.getElementsByClassName('line-header')[0].innerHTML = 'Links:'
    $('<div class="link-container champ-card" style="width: 100%; position: relative;">
          <div class="link-details" style="float: left; width: 90%">
            <h3 style="margin-bottom: 0; margin-top: 0;">Link Name:</h3>
            <input type="text" maxlength="23">
            <h3 style="margin-bottom: 0;">Link Description:</h3>
            <input type="text">
            <h3 style="margin-bottom: 0;">Location (URL):</h3>
            <input type="text">
          </div>
          <div class="link-controls" style="width: 10%; padding: 3%; float: right;">
            <a class="btn" style="margin: 17%;" onclick="addContactDetailLink(this)">+</a>
            <a class="btn" style="margin: 17%;" onclick="deleteContactDetailLink(this)">−</a>
            <a class="btn" style="margin: 17%;" onclick="moveContactLinkUp(this)">↑</a>
            <a class="btn" style="margin: 17%;" onclick="moveContactLinkDown(this)">↓</a>
          </div>
          <p>* For email addresses preface location with mailto: as such mailto:example@champlain.edu</p>
       </div>').insertAfter(button.parentNode.parentNode.getElementsByClassName('line-header')[0])
    
  else
    $(button.parentNode.parentNode.getElementsByClassName('link-container')).remove()
    button.parentNode.getElementsByTagName('input')[2].disabled = false
    
    button.parentNode.parentNode.getElementsByClassName('line-header')[0].innerHTML = 'Lines:'
    $('<div class="line-container">
      <input type="text" maxlength="24" style="width: 45%; border: 1px solid lightgrey; box-sizing: border-box; border: 2px solid #ccc; border-radius: 4px; font-size: 16px; background-color: white;padding: 7px; margin-bottom: 5px;" class="line">
      <a class="btn" onclick="addContactDetailLine(this)">+</a>
      <a class="btn" onclick="deleteContactDetailLine(this)">−</a>
      <a class="btn" onclick="moveUp(this)">↑</a>
      <a class="btn" onclick="moveDown(this)">↓</a>
      </div>').insertAfter(button.parentNode.parentNode.getElementsByClassName('line-header')[0])
  
  return

@addContactDetailLink = (button) ->
  $('<div class="link-container champ-card" style="width: 100%; position: relative;">
          <div class="link-details" style="float: left; width: 90%">
            <h3 style="margin-bottom: 0; margin-top: 0;">Link Name:</h3>
            <input type="text" maxlength="23">
            <h3 style="margin-bottom: 0;">Link Description:</h3>
            <input type="text">
            <h3 style="margin-bottom: 0;">Location (URL):</h3>
            <input type="text">
          </div>
          <div class="link-controls" style="width: 10%; padding: 3%; float: right;">
            <a class="btn" style="margin: 17%;" onclick="addContactDetailLink(this)">+</a>
            <a class="btn" style="margin: 17%;" onclick="deleteContactDetailLink(this)">−</a>
            <a class="btn" style="margin: 17%;" onclick="moveContactLinkUp(this)">↑</a>
            <a class="btn" style="margin: 17%;" onclick="moveContactLinkDown(this)">↓</a>
          </div>
          <p>* For email addresses preface location with mailto: as such mailto:example@champlain.edu</p>
       </div>').insertAfter(button.parentNode.parentNode)
  return
  
@deleteContactDetailLink = (button) ->
  if button.parentNode.parentNode.parentNode.getElementsByClassName('link-container').length - 1
    $(button.parentNode.parentNode).remove()
  return

#Pre: takes in the button that calls this function
#Post: moves the parent element of the button above the previous element
#as long as they are the same type
#Purpose: this function is meant to help reorganize elements of different templates
@moveContactLinkUp = (button) ->
  prevElement = $(button.parentElement.parentElement).prev()
  #if the element previous to the one selected is of the same type then we will move our element before it
  if $(button.parentElement.parentElement).prop("tagName") is $(prevElement).prop("tagName")
    $(button.parentElement.parentElement).detach().insertBefore(prevElement)
  return

#Pre: takes in the button that calls this function
#Post: moves the parent element of the button below the next element
#as long as they are the same type
#Purpose: this function is meant to help reorganize elements of different templates
@moveContactLinkDown = (button) ->
  nextElement = $(button.parentElement.parentElement).next()
  if $(button.parentElement.parentElement).prop("tagName") is $(nextElement).prop("tagName")
    $(button.parentElement.parentElement).detach().insertAfter(nextElement)
  return
  
#Pre: Contact Book Detail
#Post: Replaces Lines with Buttons or vice Versa
#Post: To allow for buttons in the contact book
@contactDetailIsButton = (button) ->
  console.log button
  if button.checked
    # If the button is checked we want to remove any lines that may exist and disable the 'Detail is Link' button
    $(button.parentNode.parentNode.getElementsByClassName('line-container')).remove()
    button.parentNode.getElementsByTagName('input')[1].disabled = true
    
    button.parentNode.parentNode.getElementsByClassName('line-header')[0].innerHTML = 'Button:'
    $('<div class="btn-container" style="width: 100%; position: relative;">
        <h3 style="margin-bottom: 0; margin-top: 0;">Button Name:</h3>
        <input type="text" maxlength="18">
        <h3 style="margin-bottom: 0;">Button Description:</h3>
        <input type="text">
        <h3 style="margin-bottom: 0;">Location (URL):</h3>
        <input type="text">
        <p>* Only one button per detail</p>
      </div>').insertAfter(button.parentNode.parentNode.getElementsByClassName('line-header')[0])
  
  else
    $(button.parentNode.parentNode.getElementsByClassName('btn-container')).remove()
    button.parentNode.getElementsByTagName('input')[1].disabled = false
    
    button.parentNode.parentNode.getElementsByClassName('line-header')[0].innerHTML = 'Lines:'
    $('<div class="line-container">
          <input type="text" maxlength="24" style="width: 45%; border: 1px solid lightgrey; box-sizing: border-box; border: 2px solid #ccc; border-radius: 4px; font-size: 16px; background-color: white;padding: 7px; margin-bottom: 5px;" class="line">
          <a class="btn" onclick="addContactDetailLine(this)">+</a>
          <a class="btn" onclick="deleteContactDetailLine(this)">−</a>
          <a class="btn" onclick="moveUp(this)">↑</a>
          <a class="btn" onclick="moveDown(this)">↓</a>
        </div>').insertAfter(button.parentNode.parentNode.getElementsByClassName('line-header')[0])
  return