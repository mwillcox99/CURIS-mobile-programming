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
		event.relatedTarget.blockName = event.relatedTarget.textContent
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
			event.target.textContent = 'Dropzone'
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

# target elements with the "draggable" class
interact('.draggable').draggable
	onmove: (event) ->
		dragMove event
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
	inertia: true

	# dropzone class can accept blocks draggable class
	setupDropzone '.dropzone', '.draggable'

interact('.body')