#
# Referenced interact.js-master/demo/js/dropzones.js
#

# $ ->
# 	for draggable, i in $ '.draggable'
# 		$(draggable).attr 'data-x', i*240 + 50
# 		$(draggable).attr 'data-y', 100
# 		# console.log draggable
# 		console.log $(draggable).data 'y'

dragMove = (event) ->
	target = event.target
	# Change position
	x = (parseFloat(event.target.getAttribute('data-x')) or 0) + event.dx
	y = (parseFloat(event.target.getAttribute('data-y')) or 0) + event.dy

	# Transform element
	target.style.left = x + 'px'
	target.style.top = y + 'px'

	# Update position
	target.setAttribute 'data-x', x
	target.setAttribute 'data-y', y

addClass = (element, className) ->
	if element.classList
		return element.classList.add(className)
	else
		element.className += ' ' + className
	return

removeClass = (element, className) ->
	if element.classList
		return element.classList.remove(className)
	else
		element.className = element.className.replace(new RegExp(className + ' *', 'g'), '')
	return

setupDropzone = (el, accept) ->
	interact(el).dropzone
		accept: accept
		ondropactivate: (event) ->
			addClass event.relatedTarget, '-drop-possible'
			return
		ondropdeactivate: (event) ->
			removeClass event.relatedTarget, '-drop-possible'
			return
	.on 'dropactivate', (event) ->
		event.target.dropzoneName = event.target.textContent
		active = event.target.getAttribute('active') | 0
		if active == 0
			addClass event.target, '-drop-possible'
			addClass event.relatedTarget, '-drop-possible'
			event.target.textContent = 'Drop here!'
			event.target.setAttribute 'active', active + 1
			return
	.on 'dropdeactivate', (event) ->
		active = event.target.getAttribute('active') | 0
		if active == 1
			removeClass event.target, '-drop-possible'
			event.target.textContent = event.target.dropzoneName
			event.target.setAttribute 'active', active - 1
			return
	.on 'dragenter', (event) ->
		addClass event.target, '-drop-over'
		console.log 'I\'m in'
		return
	.on 'dragleave', (event) ->
		removeClass event.target, '-drop-over'
		removeClass event.relatedTarget, '-drop-over'
		console.log 'I\'m out'
		return
	.on 'drop', (event) ->
		removeClass event.target, '-drop-over'
		addClass event.relatedTarget, '-drop-over'
		console.log 'Dropped'
		return
	return

weatherIcons = ["wi wi-umbrella", "wi wi-cloudy", "wi wi-day-sunny"]
count = 0
	
interact('#drag2')
	.on 'tap', (event) ->
		console.log 'Changed icon'
		icon = weatherIcons[count]
		$("#weather").removeClass weatherIcons[count-1]
		$("#weather").addClass icon
		count++;
		if count is weatherIcons.length then count=0
		return

#target elements with the "draggable" class
 interact('.draggable').draggable
 	onmove: (event) ->
 		dragMove event
 	inertia: true
 	restrict:
 		restriction: 'body'
 		endOnly: true
 		elementRect:
 			top: 0
 			left: 0
 			bottom: 1
 			right: 1
 	axis: 'xy'
 	max: Infinity
 	maxPerElement: 2

 	# dropzone class can accept blocks draggable class
 	setupDropzone '.dropzone', '.draggable'

 interact('#drag1').draggable(
   snap:
     targets:
       x:100
       y:100
     range: Infinity
     relativePoints:[{
       x: 0
       y: 0
     }]
   inertia: true
   restrict:
     restriction: 'body'
   elementRect:
     top: 0
     left: 0
     bottom: 1
     right: 1
   endOnly: true).on 'dragmove', (event) ->
     x += event.dx
     y += event.dy
     event.target.style.webkitTransform = event.target.style.transform = 'translate(' + x + 'px, ' + y + 'px)'

# weatherIcons = ["wi wi-umbrella", "wi wi-cloudy", "wi wi-day-sunny"]
# count = 0
###$("#drag2").click ->
	alert "SDF "
	icon = weatherIcons[count]
	console.log icon
	$("#weather").removeClass weatherIcons[count-1]
	$("#weather").addClass icon
	count++;
	if count is weatherIcons.length then count=0
	return###
	
